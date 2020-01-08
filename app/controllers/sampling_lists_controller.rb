class SamplingListsController < ApplicationController
  after_action :assign_date_to_samplings, only: [:create, :update], unless: -> { @sampling_list.nil? }
  load_and_authorize_resource

  # GET /sampling_lists
  # GET /sampling_lists.json
  def index
    @sampling_lists = SamplingList.all.includes(:access, :frecuency).order('created_at DESC')
  end

  # GET /sampling_lists/1
  # GET /sampling_lists/1.json
  def show
    @plant = Plant.find(params[:plant_id])
    @sampling_list = @plant.sampling_lists.find(params[:id])
    @samplings = @sampling_list.samplings.includes(standard: :option)
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: 'Access not Allowed'
  end

  # GET /sampling_lists/new
  def new
    @sampling_list = SamplingList.new
  end

  # GET /sampling_lists/1/edit
  def edit
    @plant = Plant.find(params[:plant_id])
    @sampling_list = @plant.sampling_lists.find(params[:id])
    @samplings = @sampling_list.samplings.includes(standard: [:option])
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: 'Access not Allowed'
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
    @sampling_list.inactive!
    respond_to do |format|
      format.html { redirect_to sampling_lists_url, notice: 'Sampling list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def lab
    lab_sampling = @plant.sampling_lists.lab.last
    redirect_to edit_plant_sampling_list_path(@plant, lab_sampling)
  end

  def internal
    lab_sampling = @plant.sampling_lists.internal.last
    redirect_to edit_plant_sampling_list_path(@plant, lab_sampling)
  end

  private

  def assign_date_to_samplings
    @sampling_list.samplings.map do |sampling|
      sampling.date = @sampling_list.date
      sampling.save
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sampling_list_params
    params.require(:sampling_list).permit(:date, samplings_attributes: %i[id standard_id value_in value_out sampling_list_id])
  end
end
