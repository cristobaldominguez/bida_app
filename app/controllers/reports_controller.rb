class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_state, only: [:new, :create, :edit, :update]
  before_action :set_plant, only: [:index, :show, :new, :create, :edit, :update]

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

    @plant.graph_standards.each do |gs|
      @report.graphs.build(graph_standard: gs)
    end

    @graphs = @report.graphs
  end

  # GET /reports/1/edit
  def edit
    @graphs = @report.graphs
    # raise
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

  def report_params
    params.require(:report).permit(:plant_id, :state)
  end
end
