class AlertsController < ApplicationController
  before_action :set_create_assignment, only: :create
  before_action :set_incident_type, :set_status, :set_priority, only: [:new, :edit, :create, :update]
  load_and_authorize_resource

  # GET /alerts
  # GET /alerts.json
  def index
    @alerts = Alert.active.includes(:incident_type)
    @plant = Plant.find(params[:plant_id])
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
    @plant = Alert.find(params[:id]).plant
  end

  # GET /alerts/new
  def new
    @plant = Plant.find(params[:plant_id])
    @alert = @plant.alerts.build
  end

  # POST /alerts
  # POST /alerts.json
  def create
    respond_to do |format|
      if @alert.save
        @alert.send_notifications!
        format.html { redirect_to plant_path(@alert.plant), notice: 'Alert was successfully created.' }
        format.json { render :show, status: :created, location: @alert }
      else
        format.html { render :new }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /alerts/1/edit
  def edit
    @plant = Alert.find(params[:id]).plant
  end

  # PATCH/PUT /alerts/1
  # PATCH/PUT /alerts/1.json
  def update
    params[:alert][:status_id] = params[:alert][:incident_resolution].length > 10 ? Status.find_by(name: "Fixed").id : params[:alert][:status_id]

    respond_to do |format|
      if @alert.update(alert_params)
        format.html { redirect_to plant_alerts_path(@plant), notice: 'Alert was successfully updated.' }
        format.json { render :show, status: :ok, location: @alert }
      else
        format.html { render :edit }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert.inactive!
    respond_to do |format|
      format.html { redirect_to plant_alerts_path(@plant), notice: 'Alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_incident_type
    @incidents = IncidentType.all
  end

  def set_status
    @statuses = Status.all
  end

  def set_priority
    @priorities = Priority.all
  end

  def set_create_assignment
    @alert = Alert.new(alert_params)
    @alert.user = current_user
    @alert.plant = Plant.find(params[:plant_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def alert_params
    params.require(:alert).permit(:user_id, :plant_id, :incident_type_id, :status_id,
      :priority_id, :incident_description, :negative_impact, :solution, :incident_resolution,
      :solution_target_date, :technician_hours_required, user_ids: [])
  end
end
