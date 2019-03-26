class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_state, only: [:new, :create, :edit, :update]
  before_action :set_plant, only: [:index, :show, :new, :create, :edit, :update]
  # before_action :set_graphs_data, only: [:new, :edit, :show]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.active.order(created_at: :desc)
  end

  # GET /reports/1
  # GET /reports/1.json
  def show; end

  # GET /reports/new
  def new
    @report = Report.new
    @report.plant = @plant
    @report.system_purpose = @plant.system_purpose
    @report.report_preface = @plant.report_preface
    @report.flow_design = "#{@plant.flow_design} #{@plant.country.metric.volume.pluralize(@plant.flow_design)} Per Day"
    @report.system_size = @plant.system_size
    @report.date = Date.today
    graph_standards = @plant.graph_standards.includes(:chart)

    graph_standards.each do |gs|
      @report.graphs.build(graph_standard: gs)
    end

    @graphs = @report.graphs
    set_graphs_data(@report)

  end

  # GET /reports/1/edit
  def edit
    @graphs = @report.graphs
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)
    @report.plant = @plant
    @report.system_purpose = @plant.system_purpose
    @report.report_preface = @plant.report_preface
    @report.flow_design = "#{@plant.flow_design} #{@plant.country.metric.volume.pluralize(@plant.flow_design)} Per Day"
    @report.system_size = @plant.system_size

    respond_to do |format|
      if @report.save
        format.html { redirect_to plant_report_path(@plant, @report), notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.active = false
    @report.save

    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def set_plant
    @plant = Plant.find(params[:plant_id])
  end

  def set_state
    @state = Report.states
  end

  def set_graphs_data(report)
    start_date = report.date.beginning_of_month
    end_date = report.date.end_of_month
    minimum_liquid_required = 0.05 * @plant.flow_design
    @monthly_flow = @plant.flows.where('date BETWEEN ? AND ?', (start_date - 11.months), end_date).group_by_month(:date).sum(:value).map { |k, v| [k.strftime('%b, %Y'), v] }
    @daily_flow = @plant.flows.where('date BETWEEN ? AND ?', start_date, end_date).order(:id).pluck(:value, :date).map { |prim, seg| [seg.strftime('%d/%m'), prim] }
    # sampling_list = @plant.sampling_lists.includes(:access, samplings: [standard: :option]).where('created_at BETWEEN ? AND ?', start_date, end_date).select {|sl| sl.access.name == 'Internal' }.first

    sampling_lists = @plant.sampling_lists.includes(:access, samplings: [standard: :option])
    # sampling_lists = @plant.sampling_lists

    # @monthly_water
    current_sampling_list = sampling_lists.select { |n| n.created_at.between?(start_date, end_date) }.select { |sl| sl.access.name == 'Internal' }.first
    monthly_water_values = current_sampling_list.samplings.group_by { |s| s.standard.option.name }.map do |key, value|
      value_in = value.map(&:value_in).sum
      value_out = value.map(&:value_out).sum
      percent = (100 - (value_out * 100) / value_in).round(1)
      { key.to_sym => [value_in, value_out, percent.to_s + '%'] }
    end

    # @treated_water
    treated_water = @plant.flows.reject { |flow| flow.date > end_date }.reject { |flow| flow.value < minimum_liquid_required }.group_by_month(&:date)
    treated_water_total_by_month = treated_water.map { |_, group| group.sum(&:value) }
    treated_water_irrigated_by_month = treated_water.map { |_, group| group.size }
    treated_water_peak_by_month = treated_water.map { |_, group| group.max_by(&:value) }.map(&:value)

    treated_water = {
      total: {
        last_month: treated_water_total_by_month.last.round(1),
        last_year: treated_water_total_by_month.last(12).sum.round(1),
        lifetime: treated_water_total_by_month.sum.round(1)
      },
      irrigated: {
        last_month: treated_water_irrigated_by_month.last.round(1),
        last_year: treated_water_irrigated_by_month.last(12).sum.round(1),
        lifetime: treated_water_irrigated_by_month.sum.round(1)
      },
      peak: {
        last_month: treated_water_peak_by_month.last.round(1),
        last_year: treated_water_peak_by_month.last(12).sum.round(1),
        lifetime: treated_water_peak_by_month.sum.round(1)
      }
    }

    treated_water_average = {
      last_month: (treated_water[:total][:last_month] / treated_water[:irrigated][:last_month]).round(0),
      last_year: (treated_water[:total][:last_year] / treated_water[:irrigated][:last_year]).round(0),
      lifetime: (treated_water[:total][:lifetime] / treated_water[:irrigated][:lifetime]).round(0)
    }

    treated_water_data = [{ "Total #{@plant.metrics.volume.pluralize}" => [treated_water[:total][:last_month], treated_water[:total][:last_year], treated_water[:total][:lifetime]] },
                          { 'Days Irrigated' => [treated_water[:irrigated][:last_month], treated_water[:irrigated][:last_year], treated_water[:irrigated][:lifetime]] },
                          { 'Average GPD' => [treated_water_average[:last_month], treated_water_average[:last_year], treated_water_average[:lifetime]] },
                          { 'Peak Flow' => [treated_water[:peak][:last_month], treated_water[:peak][:last_year], treated_water[:peak][:lifetime]] }]

    # Lifetime Water Analysis Overview
    current_sampling_lists = sampling_lists.select { |sampling_list| sampling_list.access.name == 'Internal' }
    grouped_samplings = current_sampling_lists.map { |sl| sl.samplings.map { |sampling| sampling } }.flatten.group_by { |sampling| sampling.standard.option.name }
    grouped_by_month = grouped_samplings.map { |key, values| { key => values.group_by_month(&:created_at) } }
    sampling_numbers = grouped_by_month.map { |elems| elems.map { |list, values| { list => values.map { |key, value| { key => [value.sum(&:value_in), value.sum(&:value_out)] } } } } }.flatten
    lifetime_analysis = sampling_numbers.map { |arr| arr.map { |key, sampls| data_in = sampls.map { |samp| samp.map { |_, v| v[0] }.sum }; data_out = sampls.map { |samp| samp.map { |_, v| v[1] }.sum }; value_in = (data_in.map.inject(:+) / data_in.length).round(1); value_out = (data_out.map.inject(:+) / data_out.length).round(1); value_removal = (100 - (value_out * 100) / value_in).round(1); { key => { in: value_in, out: value_out, removal: value_removal } } } }.flatten

    # sampling_numbers.map { |data| data.map { |key, values| { key => [values.map { |info| info.map { |_, val| val[0] }.flatten }, values.map { |info| info.map { |_, val| val[0] }.flatten }] } } }
    average_values = grouped_by_month.map { |elems| elems.map { |list, values| { list => values.map { |key, value| value_in = (value.sum(&:value_in) / value.size).round(1); value_out = (value.sum(&:value_out) / value.size).round(1); { key => [value_in, value_out] } } } } }.flatten
    flatten_numbers = average_values.map { |data| data.map { |key, values| { key => { in: values.map { |dat| dat.map { |_, v| v[0] } }.flatten, out: values.map { |dat| dat.map { |_, v| v[1] } }.flatten } } } }.flatten
    peak_values = flatten_numbers.map { |data| data.map { |k, v| value_in = v[:in].max; value_out = v[:out].max; value_removal = (100 - (value_out * 100) / value_in).round(1); { k => { in: value_in, out: value_out, removal: value_removal } } } }.flatten

    @monthly_water = { "headers": ['', 'BIDA In', 'BIDA Out', 'Removal'], "data": monthly_water_values }
    @treated_water = { "headers": ['', 'Month', 'Year', 'Lifetime'], "data": treated_water_data }
    @lifetime_analysis = { "headers": [['', 'Biological Oxygen Demand', 'Total Suspended Solids'], ['BOD In', 'BOD Out', 'Removal', 'TSS In', 'TSS Out', 'Removal']], "average": lifetime_analysis, "peak": peak_values }

    # raise
  end

  def report_params
    params.require(:report).permit(:plant_id, :state)
  end
end
