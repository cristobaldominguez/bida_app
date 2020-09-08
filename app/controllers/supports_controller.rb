class SupportsController < ApplicationController
  before_action :set_create_assignment, only: :create
  before_action :generate_users, only: [:new, :create, :edit, :update]
  load_and_authorize_resource

  # GET /supports
  # GET /supports.json
  def index
    @plant = Plant.find(params[:plant_id])
    @supports = @plant.supports.active.order('id DESC')
  end

  # GET /supports/1
  # GET /supports/1.json
  def show
    @support.work_summaries = @support.work_summaries.active
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: t(:access_not_allowed, scope: :global)
  end

  # GET /plants/1/supports/new
  def new
    @support = @plant.supports.build
    @support.work_summaries.build
  end

  # POST /plants/1/supports
  # POST /plants/1/supports.json
  def create
    respond_to do |format|
      if @support.save
        @support.send_notifications!
        format.html { redirect_to plant_supports_path(@plant), notice: t(:successfully_created, scope: :inspection) }
        format.json { render :show, status: :created, location: @support }
      else
        format.html { render :new }
        format.json { render json: @support.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /supports/1/edit
  def edit
    @work_summary = @support.work_summaries.build if @support.work_summaries.empty?
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: t(:access_not_allowed, scope: :global)
  end

  # PATCH/PUT /plants/1/plants/1/supports/1
  # PATCH/PUT /plants/1/plants/1/supports/1.json
  def update
    respond_to do |format|
      if @support.update(support_params)
        format.html { redirect_to plant_supports_path(@plant), notice: t(:successfully_updated, scope: :inspection) }
        format.json { render :show, status: :ok, location: @support }
      else
        format.html { render :edit }
        format.json { render json: @support.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supports/1
  # DELETE /supports/1.json
  def destroy
    @support.inactive!
    respond_to do |format|
      format.html { redirect_to plant_supports_path(@plant), notice: t(:successfully_deleted, scope: :inspection) }
      format.json { head :no_content }
    end
  end

  # GET /plants/1/supports/custom.js
  def custom
    respond_to do |format|
      format.js
    end
  end

  private

  def set_create_assignment
    @support = Support.new(support_params)
    @support.plant = Plant.find(params[:plant_id])
    @support.user = current_user
  end

  def generate_users
    @users = User.filtered_by(@plant).sort
    @company_users = User.filtered_by(@plant).from_company.sort
    @biofiltro_users = User.filtered_by(@plant).from_biofiltro.sort
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def support_params
    params.require(:support).permit(:active, :number, :start_date, :end_date,
      :client_onsite, :client_id, :bf_technician_id, user_ids: [],
      work_summaries_attributes: [:description, :hours, :materials, :id, :_destroy, :active])
  end
end
