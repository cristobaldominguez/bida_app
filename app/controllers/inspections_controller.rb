class InspectionsController < ApplicationController
  before_action :set_create_assignment, only: :create
  before_action :generate_users, only: [:new, :create, :edit, :update]
  prepend_before_action :set_variables, only: %i[new create edit update]
  load_and_authorize_resource

  # GET /inspections
  # GET /inspections.json
  def index
    @plant = Plant.find(params[:plant_id])
    @inspections = @plant.inspections.active.order('id DESC')
  end

  # GET /inspections/1
  # GET /inspections/1.json
  def show
    @plant = Plant.find(params[:plant_id])
    @inspection = @plant.inspections.find(params[:id])
    @fluents = @inspection.fluents.includes(:output, :color, :odor).order(:output_id)
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: 'Access not Allowed'
  end

  # GET /inspections/new
  def new
    @inspection = Inspection.new
    @plant = Plant.find(params[:plant_id])

    outputs = Output.all
    outputs.each do |output|
      @inspection.fluents.build(output: output)
    end
  end

  # GET /inspections/1/edit
  def edit
    @plant = Plant.find(params[:plant_id])
    @inspection = @plant.inspections.find(params[:id])
    @fluents = @inspection.fluents.includes(:output)
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: 'Access not Allowed'
  end

  # POST /inspections
  # POST /inspections.json
  def create
    respond_to do |format|
      if @inspection.save
        @inspection.send_notifications!
        format.html { redirect_to plant_inspections_path(@plant), notice: 'Inspection was successfully created.' }
        format.json { render :show, status: :created, location: @inspection }
      else
        format.html { render :new }
        format.json { render json: @inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inspections/1
  # PATCH/PUT /inspections/1.json
  def update
    respond_to do |format|
      if @inspection.update(inspection_params)
        format.html { redirect_to plant_inspections_path(@plant), notice: 'Inspection was successfully updated.' }
        format.json { render :show, status: :ok, location: @inspection }
      else
        format.html { render :edit }
        format.json { render json: @inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inspections/1
  # DELETE /inspections/1.json
  def destroy
    @inspection.inactive!
    respond_to do |format|
      format.html { redirect_to plant_inspections_path(@plant), notice: 'Inspection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_create_assignment
    @inspection = Inspection.new(inspection_params)
    @inspection.user = current_user
    @inspection.plant = Plant.find(params[:plant_id])
  end

  def set_variables
    @plant = Plant.find(params[:plant_id])
    @screens = Screen.all_options
    @collectionbins = CollectionBin.all_options
    @noises = Noise.all_options
    @sprinklers_pressures = SprinklersPressure.all_options
    @sprinklers_heads = SprinklersHead.all_options
    @pipings = Piping.all_options
    @system_surfaces = SystemSurface.all_options
    @bed_compactions = BedCompaction.all_options
    @pondings = Ponding.all_options
    @flies = Fly.all_options
    @birds = [[I18n.t(:_yes, scope: :global), true], [I18n.t(:_no, scope: :global), false]]
    @on_site_client = [[I18n.t(:_yes, scope: :global) + ' (Describe)', true], [I18n.t(:_no, scope: :global), false]]
    @worms_color = WormsColor.all_options
    @worms_activity = WormsActivity.all_options
    @worms_density = WormsDensity.all_options
    @colors = Color.all_options
    @odors = Odor.all_options
  end

  def generate_users
    @users = User.filtered_by(@plant).sort
    @company_users = User.from_company.sort
    @biofiltro_users = User.filtered_by(@plant).from_biofiltro.sort
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # :inspection_id, :worms_color_id, :color_description, :worms_activity_id, :activity_description, :worms_density_id
  def inspection_params
    params.require(:inspection).permit(:active, :date, :user_id, :plant_id, :on_site_client, :on_site_user_id, :report_technician_id,
      :screen_id, :collection_bin_id, :screen_comments, :noise_id, :pumps_noise_description, :pumps_psi, :sprinklers_pressure_id,
      :sprinklers_head_id, :piping_id, :pumps_comments, :system_surface_id, :bed_compaction_id, :ponding_id, :bida_comments,:odor_id,
      :plant_odor_description, :birds, :fly_id, :summary_comments, :worms_color_id, :worms_color_description, :worms_activity_id,
      :worms_activity_description, :worms_density_id, user_ids: [],
      fluents_attributes: %i[id output_id ph color_id color_description odor_id odor_description cod ec bod tss tn tp sample_comments])
  end
end
