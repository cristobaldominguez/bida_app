class InspectionsController < ApplicationController
  before_action :set_create_assignment, only: :create
  before_action :set_inspection, only: [:show, :edit, :update, :destroy]

  # GET /inspections
  # GET /inspections.json
  def index
    @inspections = Inspection.all
  end

  # GET /inspections/1
  # GET /inspections/1.json
  def show
  end

  # GET /inspections/new
  def new
    @inspection = Inspection.new
    @screens = Screen.all
    @collectionbins = CollectionBin.all
    @noices = Noice.all
    @sprinklers_pressures = SprinklersPressure.all
    @sprinklers_heads = SprinklersHead.all
    @pipings = Piping.all
    @system_surfaces = SystemSurface.all
    @bed_compactions = BedCompaction.all
    @pondings = Ponding.all
    @odors = Odor.all
    @flies = Fly.all
    @birds = [['Yes', true], ['No', false]]
    @worms_color = WormsColor.all
    @worms_activity = WormsActivity.all
    @worms_density = WormsDensity.all
    @colors = Color.all
    @odors = Odor.all

    outputs = Output.all
    outputs.each do |output|
      @inspection.fluents.build(output: output)
    end

    # raise
  end

  # GET /inspections/1/edit
  def edit
  end

  # POST /inspections
  # POST /inspections.json
  def create
    @inspection = Inspection.new(inspection_params)

    respond_to do |format|
      if @inspection.save
        format.html { redirect_to @inspection, notice: 'Inspection was successfully created.' }
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
        format.html { redirect_to @inspection, notice: 'Inspection was successfully updated.' }
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
      format.html { redirect_to inspections_url, notice: 'Inspection was successfully destroyed.' }
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def inspection_params
    params.require(:inspection).permit(:active, :user_id, :plant_id, :cod, :ec, :bod,
      :tss, :tn, :tp, :sample_comments, :screen_id, :collection_bin_id, :screen_comments,
      :noice_id, :pumps_noice_description, :pumps_psi, :sprinklers_pressure_id, :sprinklers_head_id,
      :piping_id, :pumps_comments, :system_surface_id, :bed_compaction_id, :ponding_id,
      :bida_comments, :odor_id, :plant_odor_description, :birds, :fly_id, :summary_comments,
      worms_attributes: [:inspection_id, :worms_color_id, :color_description, :worms_activity_id, :activity_description, :worms_density_id])
  end
end
