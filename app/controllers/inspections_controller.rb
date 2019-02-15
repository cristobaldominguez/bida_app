class InspectionsController < ApplicationController
  before_action :set_create_assignment, only: :create
  before_action :set_inspection, only: %i[show edit update destroy]
  prepend_before_action :set_variables, only: %i[new create edit update]

  # GET /inspections
  # GET /inspections.json
  def index
    @inspections = Inspection.active
    @plant = Plant.find(params[:plant_id])
  end

  # GET /inspections/1
  # GET /inspections/1.json
  def show; end

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
  def edit; end

  # POST /inspections
  # POST /inspections.json
  def create

    respond_to do |format|
      if @inspection.save
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
    @inspection.active = false
    @inspection.save
    respond_to do |format|
      format.html { redirect_to plant_inspections_path(@plant), notice: 'Inspection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_inspection
    @inspection = Inspection.find(params[:id])
  end

  def set_create_assignment
    @inspection = Inspection.new(inspection_params)
    @inspection.user = current_user
    @inspection.plant = Plant.find(params[:plant_id])
  end

  def set_variables
    @users = User.active
    @screens = Screen.all
    @collectionbins = CollectionBin.all
    @noises = Noise.all
    @sprinklers_pressures = SprinklersPressure.all
    @sprinklers_heads = SprinklersHead.all
    @pipings = Piping.all
    @system_surfaces = SystemSurface.all
    @bed_compactions = BedCompaction.all
    @pondings = Ponding.all
    @odors = Odor.all
    @flies = Fly.all
    @birds = [['Yes', true], ['No', false]]
    @on_site_client = [['Yes (Describe)', true], ['No', false]]
    @worms_color = WormsColor.all
    @worms_activity = WormsActivity.all
    @worms_density = WormsDensity.all
    @colors = Color.all
    @odors = Odor.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # :inspection_id, :worms_color_id, :color_description, :worms_activity_id, :activity_description, :worms_density_id
  def inspection_params
    params.require(:inspection).permit(:active, :user_id, :plant_id, :cod, :ec, :bod, :on_site_client,
      :on_site_user_id, :report_technician_id, :tss, :tn, :tp, :sample_comments, :screen_id,
      :collection_bin_id, :screen_comments, :noise_id, :pumps_noise_description, :pumps_psi, :sprinklers_pressure_id,
      :sprinklers_head_id, :piping_id, :pumps_comments, :system_surface_id, :bed_compaction_id, :ponding_id,
      :bida_comments, :odor_id, :plant_odor_description, :birds, :fly_id, :summary_comments,
      :worms_color_id, :worms_color_description, :worms_activity_id, :worms_activity_description, :worms_density_id,
      fluents_attributes: [:output_id, :ph, :color_id, :color_description, :odor_id, :odor_description])
  end
end
