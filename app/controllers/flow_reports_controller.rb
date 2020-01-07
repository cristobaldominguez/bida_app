class FlowReportsController < ApplicationController
  before_action :set_flow_report, only: [:show, :edit, :update, :destroy]

  # GET /plants/1/flow_reports
  # GET /plants/1/flow_reports.json
  def index
    @flow_reports = @plant.flow_reports.active.order(date: :desc)
  end

  # GET /plants/1/flow_reports/1
  # GET /plants/1/flow_reports/1.json
  def show
    @plant = Plant.find(params[:plant_id])
    @flow_report = @plant.flow_reports.find(params[:id])
    @flows = @flow_report.flows.order(:id)
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: 'Access not Allowed'
  end

  # GET /plants/1/flow_reports/new
  def new
    @flow_report = FlowReport.new
    days_of_month = Date.today.end_of_month.day
    days_of_month.times do |day|
      @flow_report.flows.build(plant: @plant, date: Date.new(Date.today.year, Date.today.month, day + 1))
    end
  end

  # GET /plants/1/flow_reports/1/edit
  def edit
    @plant = Plant.find(params[:plant_id])
    @flow_report = @plant.flow_reports.find(params[:id])
    @flows = @flow_report.flows.order(:id)
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: 'Access not Allowed'
  end

  # POST /plants/1/flow_reports
  # POST /plants/1/flow_reports.json
  def create
    @flow_report = FlowReport.new(flow_report_params)
    @flow_report.plant = @plant

    @flow_report.flows.each do |flow|
      flow.plant = @plant
    end

    respond_to do |format|
      if @flow_report.save
        format.html { redirect_to plant_flow_reports_path(@flow_report), notice: 'Flow report was successfully created.' }
        format.json { render :show, status: :created, location: @flow_report }
      else
        format.html { render :new }
        format.json { render json: @flow_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plants/1/flow_reports/1
  # PATCH/PUT /plants/1/flow_reports/1.json
  def update
    @flow_report.flows.each do |flow|
      flow.date = Date.new(@flow_report.date.year, @flow_report.date.month, flow.date.day)
    end
    respond_to do |format|
      if @flow_report.update(flow_report_params)
        format.html { redirect_to plant_flow_reports_path(@plant, @flow_report), notice: 'Flow report was successfully updated.' }
        format.json { render :show, status: :ok, location: @flow_report }
      else
        format.html { render :edit }
        format.json { render json: @flow_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plants/1/flow_reports/1
  # DELETE /plants/1/flow_reports/1.json
  def destroy
    @flow_report.inactive!
    respond_to do |format|
      format.html { redirect_to flow_reports_url, notice: 'Flow report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /plants/1/flow_reports/custom.js
  def custom
    params_date = params[:date].split('-').map(&:to_i)
    @days_of_month = Date.new(params_date[0], params_date[1], 1).end_of_month.day
    @month = params_date[1]
    @year = params_date[0]

    respond_to do |format|
      format.js
      format.json
    end
  end

  private

  def set_flow_report
    @flow_report = FlowReport.find(params[:id])
  end

  def flow_report_params
    params.require(:flow_report).permit(:date, flows_attributes: [:id, :value, :plant_id, :date])
  end
end
