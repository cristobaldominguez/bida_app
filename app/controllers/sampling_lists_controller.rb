class SamplingListsController < ApplicationController
  load_and_authorize_resource

  # GET /sampling_lists
  # GET /sampling_lists.json
  def index
    @sampling_lists = SamplingList.all.includes(:access, :frecuency).sort_by(&:created_at)
  end

  # GET /sampling_lists/1
  # GET /sampling_lists/1.json
  def show
    @samplings = @sampling_list.samplings
  end

  # GET /sampling_lists/new
  def new
    @sampling_list = SamplingList.new
  end

  # GET /sampling_lists/1/edit
  def edit
    @plant = @sampling_list.plant
    @samplings = @sampling_list.samplings.includes(standard: [:option])
  end

  # POST /sampling_lists
  # POST /sampling_lists.json
  def create
    @sampling_list = SamplingList.new(sampling_list_params)

    respond_to do |format|
      if @sampling_list.save
        format.html { redirect_to edit_plant_sampling_list_path(@plant, @sampling_list), notice: 'Sampling list was successfully created.' }
        format.json { render :show, status: :created, location: @sampling_list }
      else
        format.html { render :new }
        format.json { render json: @sampling_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sampling_lists/1
  # PATCH/PUT /sampling_lists/1.json
  def update
    respond_to do |format|
      if @sampling_list.update(sampling_list_params)
        format.html { redirect_to edit_plant_sampling_list_path(@plant, @sampling_list), notice: 'Sampling list was successfully updated.' }
        format.json { render :show, status: :ok, location: @sampling_list }
      else
        format.html { render :edit }
        format.json { render json: @sampling_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sampling_lists/1
  # DELETE /sampling_lists/1.json
  def destroy
    @sampling_list.active = false
    @sampling_list.save
    respond_to do |format|
      format.html { redirect_to sampling_lists_url, notice: 'Sampling list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def sampling_list_params
    params.require(:sampling_list).permit(samplings_attributes: %i[id standard_id value_in value_out sampling_list_id])
  end
end
