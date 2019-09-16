class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :set_state, only: %i[new create edit update]
  before_action :set_plant, only: %i[index show new create edit update]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.active.order(date: :desc)
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    set_graphs_data(@report)
    @graphs = @report.graphs.includes(graph_standard: :chart)
  end

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
    set_graphs_data(@report)
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
        format.html { redirect_to plant_report_path(@plant, @report), notice: 'Report was successfully updated.' }
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
    @report.inactive!
    respond_to do |format|
      format.html { redirect_to plant_reports_path(@report.plant), notice: 'Report was successfully destroyed.' }
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
    # Common variables
    report_date = report.date
    start_date = report_date.beginning_of_month
    end_date = report_date.end_of_month
    minimum_liquid_required = (0.05 * @plant.flow_design).to_i
    outputs = %w[In Out]

    # Database info
    flows_history = @plant.flows

    flows_year = flows_history.select { |flow| flow.date > start_date - 11.months && flow.date < end_date }
    flows_month = flows_history.select { |flow| flow.date >= start_date && flow.date <= end_date }

    treated_water_history = flows_history.reject { |flow| flow.value.nil? || flow.date > end_date || flow.value < minimum_liquid_required }.group_by_month(&:date)
    sampling_lists_history = @plant.sampling_lists.includes(samplings: [standard: :option]).created_before(end_date)
    sampling_lists_labs = sampling_lists_history.lab

    samplings_lab = sampling_lists_labs.map(&:samplings).flatten
    samplings_grouped_by_option = samplings_lab.group_by { |sampling| sampling.standard.option.name }

    lifetime_analysis_headers = samplings_grouped_by_option.map { |key, _| key }.map { |key| ["#{key} In", "#{key} Out", 'Removal'] }.flatten

    year_samplings = year_samplings(sampling_lists_labs, start_date)
    year_samplings_grouped_by_option = year_samplings.group_by { |sampling| sampling.standard.option.name }

    # View Variables
    @yearly_flow = yearly_water_flow(flows_year)
    @monthly_flow = monthly_water_flow(flows_month)
    @monthly_water_analysis = { "headers": ['', 'BIDA In (mg/l)', 'BIDA Out (mg/l)', 'Removal'], "data": monthly_water_analysis_data(samplings_grouped_by_option) }
    @treated_water = { "headers": ['', 'Month', 'Year', 'Lifetime'], "data": monthly_water_flow_analysis(treated_water_history) }
    @lifetime_analysis = { "headers": [['', 'Biological Oxygen Demand (mg/l)', 'Total Suspended Solids (mg/l)'], lifetime_analysis_headers],
                           "average": samplings_average(samplings_grouped_by_option), "peak": samplings_peak(samplings_grouped_by_option) }
    @year_samplings_analysis = { 'headers': [['', 'Biological Oxygen Demand (mg/l)', 'Total Suspended Solids (mg/l)'], ['Grab Date', lifetime_analysis_headers].flatten], 'data': year_samplings_tabledata(sampling_lists_labs, start_date), 'footer': [] }
    @year_samplings_grouped_by_option = outputs.map { |output| year_samplings_grouped_by_option.map { |key, values| { name: "#{key} #{output}", data: values.map { |sampling| [sampling.date.strftime('%b, %Y'), output == 'In' ? sampling.value_in : sampling.value_out] } } } }.flatten
  end

  def percent(value_in, value_out)
    (100 - (value_out * 100) / value_in).round(0)
  end

  def yearly_water_flow(flows_year)
    flows_year_grouped_by_month = flows_year.group_by_month(&:date)
    flows_year_grouped_by_month.map { |key, monthly_flows| [key.strftime('%b, %y'), monthly_flows.sum(&:value).round(0)] }
  end

  def monthly_water_flow(flows_month)
    flows_month.map { |flow| [flow.date.strftime("%b, #{flow.date.day.ordinalize}"), flow.value] }
  end

  def treated_water(data)
    hash = {}
    %i[total irrigated peak].each do |key|
      hash[key] = { last_month: data[key].last.round(0),
                    last_year: data[key].last(12).sum.round(0),
                    lifetime: data[key].sum.round(0) }
    end
    hash[:average] = { last_month: (hash[:total][:last_month] / hash[:irrigated][:last_month]),
                       last_year: (hash[:total][:last_year] / hash[:irrigated][:last_year]),
                       lifetime: (hash[:total][:lifetime] / hash[:irrigated][:lifetime]) }
    hash
  end

  def monthly_water_flow_analysis(treated_water)
    treated_water_data = {
      total: treated_water.map { |_, group| group.sum(&:value).round(0) },
      irrigated: treated_water.map { |_, group| group.size },
      peak: treated_water.map { |_, group| group.max_by(&:value) }.map(&:value)
    }

    treated_water = treated_water(treated_water_data)

    [{ "Total #{@plant.metrics.volume.pluralize}" => [treated_water[:total][:last_month], treated_water[:total][:last_year], treated_water[:total][:lifetime]] },
     { 'Days Irrigated' => [treated_water[:irrigated][:last_month], treated_water[:irrigated][:last_year], treated_water[:irrigated][:lifetime]] },
     { 'Average Flow (GPD)' => [treated_water[:average][:last_month], treated_water[:average][:last_year], treated_water[:average][:lifetime]] },
     { 'Peak Flow (GPD)' => [treated_water[:peak][:last_month], treated_water[:peak][:last_year], treated_water[:peak][:lifetime]] }]
  end

  def samplings_average(data)
    data.map do |key, value|
      value_in = (value.sum(&:value_in) / value.size).round(0)
      value_out = (value.sum(&:value_out) / value.size).round(0)
      { key => { in: value_in, out: value_out, removal: percent(value_in, value_out) } }
    end
  end

  def samplings_peak(data)
    data.map do |key, value|
      value_in = value.map(&:value_in).max.round(0)
      value_out = value.map(&:value_out).max.round(0)
      { key => { in: value_in, out: value_out, removal: percent(value_in, value_out) } }
    end
  end

  def monthly_water_analysis_data(data)
    current_samplings = data.map { |_, samplings| samplings.last }
    current_samplings.map do |sampling|
      value_in = sampling.value_in.round(0)
      value_out = sampling.value_out.round(0)
      { sampling.standard.option.name => [value_in, value_out, percent(value_in, value_out).to_s + '%'] }
    end
  end

  def year_samplings_tabledata(data, start_date)
    year_samplings_data = year_samplings(data, start_date)
    year_samplings_grouped_by_month = year_samplings_data.group_by_month(&:date)
    year_samplings_grouped_by_month.map do |key, samplings|
      { key.strftime('%B, %y') => samplings.map { |sampling| { in: sampling.value_in.round(0), out: sampling.value_out.round(0), removal: percent(sampling.value_in, sampling.value_out).to_s + '%' } } }
    end
  end

  def year_samplings(data, start_date)
    end_date = start_date - 11.months
    data.select { |sampling_list| sampling_list.date > end_date }.map(&:samplings).flatten
  end

  def report_params
    params.require(:report).permit(:plant_id, :state, :date, graphs_attributes: %i[id comment graph_standard_id])
  end
end
