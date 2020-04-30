class SamplingListsController < ApplicationController
  after_action :assign_date_to_samplings, only: [:create, :update], unless: -> { @sampling_list.nil? }
  load_and_authorize_resource

  # GET /sampling_lists
  # GET /sampling_lists.json
  def index
    @sampling_lists = @plant.sampling_lists.includes(:access).active.order('date DESC')
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
    @accesses = Access.all
  end

  # GET /sampling_lists/1/edit
  def edit
    @options = Option.all
    @accesses = Access.all
    @plant = Plant.find(params[:plant_id])

    @samplings = @sampling_list.samplings.includes(standard: :option).select(&:active)

  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: 'Access not Allowed'
  end

  # POST /sampling_lists
  # POST /sampling_lists.json
  def create
    @accesses = Access.all
    @sampling_list = SamplingList.new(sampling_list_params)
    last_sampling = @plant.sampling_lists.send(@sampling_list.access.name.downcase.to_sym).last
    @sampling_list.frecuency_id = last_sampling.frecuency_id
    @sampling_list.per_cycle = last_sampling.per_cycle
    @sampling_list.plant = @plant

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
        format.html { redirect_to plant_sampling_list_path(@plant, @sampling_list), notice: 'Sampling list was successfully updated.' }
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
      format.html { redirect_to plant_sampling_lists_url, notice: 'Sampling list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def external
    external_sampling = @plant.sampling_lists.external.last
    redirect_to edit_plant_sampling_list_path(@plant, external_sampling)
  end

  def internal
    external_sampling = @plant.sampling_lists.internal.last
    redirect_to edit_plant_sampling_list_path(@plant, external_sampling)
  end

  def self.api_new(plant, access, data = {}, date = Date.today)
    sampling_list = current_sampling_lists(plant, access)
    new_sampling_list = generate_sampling_list(sampling_list, data, date)
    generate_samplings(sampling_list, new_sampling_list, data, date)

    data.present? ? new_sampling_list : api_save(new_sampling_list)
  end

  def self.current_sampling_lists(plant, access)
    sampling_access = plant.sampling_lists.send(access.downcase)
    sampling_access.includes(:samplings).max_by(&:created_at)
  end

  def self.generate_sampling_list(sampling_list, data = {}, date = Date.today)
    sl_date = data.present? ? data[:list][:date] : date
    SamplingList.new(date: sl_date,
                     plant_id: sampling_list.plant_id,
                     access_id: sampling_list.access_id,
                     per_cycle: sampling_list.per_cycle,
                     frecuency_id: sampling_list.frecuency_id)
  end

  def self.generate_samplings(lista, sampling_list, data = {}, date = Date.today)
    lista.samplings.each do |sampling|
      current = generate_params(sampling, data)

      sampling_list.samplings.build(standard_id: sampling.standard_id, value_in: current[:value_in], value_out: current[:value_out], date: date)
    end
  end

  def self.generate_params(sampling, data)
    current_data = data[:samplings].select { |s| s[:option] == sampling.standard.option.name }.first || {}

    { value_in: current_data[:value_in], value_out: current_data[:value_out], date: current_data[:date] || Date.today }
  end

  def self.api_save(sampling_list)
    if sampling_list.valid? && sampling_list.samplings.map(&:valid?).all?
      sampling_list.save
      true
    else
      handle_errors(sampling_list)
      false
    end
  end

  def handle_errors(sampling_list)
    sampling_list.samplings.each_with_index do |item, index|
      item.errors.full_messages.each do |msg|
        errors.add :base, "Row #{index + 6}: #{msg}"
      end
    end
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
    params.require(:sampling_list).permit(:date, :access_id, :frecuency_id, :per_cycle,
                                          samplings_attributes: [:id, :value_in, :value_out, :sampling_list_id,
                                            standard_attributes: [:id, :plant_id, :isRange,
                                              option_attributes: [:id, :name]]])
  end
end
