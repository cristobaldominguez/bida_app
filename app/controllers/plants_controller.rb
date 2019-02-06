class PlantsController < ApplicationController
  before_action :set_plant, only: %i[show edit update destroy]
  before_action :set_company, only: %i[show create update destroy]
  before_action :set_companies, only: :index
  before_action :set_discharge_points, :set_countries, only: %i[new edit create update]
  before_action :set_users, :set_frecuencies, only: %i[new edit create update]
  before_action :set_accesses, only: %i[create]

  # GET companies/:company_id/plants
  # GET companies/:company_id/plants.json
  def index
    @plants = Company.find(params[:company_id]).plants.active
    @company = Company.find(params[:company_id])
  end

  # GET companies/:company_id/plants/1
  # GET companies/:company_id/plants/1.json
  def show
    @alerts = @plant.alerts.active
    @supports = @plant.supports.active
    @inspections = @plant.inspections.active
    @standards = @plant.standards.includes(:option, :bounds)
    @sampling_lists = @plant.sampling_lists.includes(:access, samplings: :standard)
    @log_standards = @plant.log_standards.includes(:frecuency, task: :log_type).order('log_types.id')

    @logbook = @plant.logbooks.last.created_at.month == Date.today.month ? edit_logbook_path(@plant.logbooks.last) : new_plant_logbook_path(@plant)
    @lab_samplings = check_sampling_link(@plant, 'Lab')
    @internal_samplings = check_sampling_link(@plant, 'Internal')
  end

  # GET companies/:company_id/plants/new
  def new
    @company = Company.find(params[:company_id])
    @plant = @company.plants.build
    @is_new = true

    outlets = Outlet.all
    options = Option.all
    accesses = Access.all
    standards = []
    sampling_lists = []

    options.each do |option|
      standards << @plant.standards.build(option: option)
    end

    standards.each do |standard|
      outlets.each do |outlet|
        standard.bounds.build(outlet: outlet)
      end
    end

    accesses.each do |access|
      sampling_lists << @plant.sampling_lists.build(access: access, per_cycle: 1)
    end

    standards.each do |standard|
      sampling_lists.each do |sampling_list|
        sampling_list.samplings.build(standard: standard)
      end
    end
  end

  # POST companies/:company_id/plants
  # POST companies/:company_id/plants.json
  def create
    @plant = @company.plants.build(plant_params)
    accesses = Access.all
    samplings_names = {}

    accesses.each do |access|
      symbol = access.name.convert_as_parameter.to_sym
      samplings_names[symbol] = params[symbol].keys
    end

    @plant.sampling_lists.each do |sampling_list|
      samplings_names[sampling_list.access.name.convert_as_parameter.to_sym].each do |sn|
        standard = @plant.standards.select { |stan| stan.option.name.convert_as_parameter == sn.convert_as_parameter }.first
        sampling_list.samplings.build(standard: standard)
        sampling_list.save
      end
    end

    respond_to do |format|
      if @plant.save
        format.html { redirect_to @plant, notice: 'Plant was successfully created.' }
        format.json { render :show, status: :created, location: @plant }
      else
        format.html { render :new }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET companies/:company_id/plants/1/edit
  def edit
    @plant = Plant.find(params[:id])
    @company = @plant.company
    sampling_lists = @plant.sampling_lists

    sampling_lists.order(created_at: :desc).limit(2).each do |sl|
      @plant.standards.each do |stdr|
        sl.samplings.build(standard: stdr)
      end
    end

    sampling_lists.each do |sampling_list|
      @plant.standards.each do |standard|
        sampling_list.samplings.find_or_initialize_by(standard: standard)
      end
    end
  end

  # PATCH/PUT companies/:company_id/plants/1
  # PATCH/PUT companies/:company_id/plants/1.json
  def update
    options_sym = Option.all.map { |op| op.name.convert_as_parameter.to_sym }
    @plant.system_size = params[:plant][:system_size].split(' ').map(&:to_i)

    @plant.sampling_lists.each do |sl|
      acc = sl.access.name
      all_params = params[acc.convert_as_parameter.to_sym].permit(options_sym).to_h.map { |k, _| k }

      all_params.each do |p|
        strds = @plant.standards.select { |standard| standard.option.name.convert_as_parameter == p }

        if strds.first.samplings.empty?
          sl.samplings.build(standard: strds.first)
          sl.save
        end
      end
    end

    respond_to do |format|
      if @plant.update(plant_params)
        format.html { redirect_to @plant, notice: 'Plant was successfully updated.' }
        format.json { render :show, status: :ok, location: @plant }
      else
        format.html { render :edit }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE companies/:company_id/plants/1
  # DELETE companies/:company_id/plants/1.json
  def destroy
    @plant.active = false
    @plant.save
    respond_to do |format|
      format.html { redirect_to company_path(@company), notice: 'Plant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_plant
    @plant = Plant.find(params[:id])
  end

  def set_company
    @company = params[:company_id].nil? ? Plant.find(params[:id]).company : Company.find(params[:company_id])
  end

  def set_companies
    @companies = Company.all
  end

  def set_countries
    @countries = Country.all
  end

  def set_discharge_points
    @points = DischargePoint.all
  end

  def set_users
    @users = User.active
  end

  def set_frecuencies
    @frecuencies = Frecuency.all
  end

  def set_accesses
    accesses = Access.all
  end

  def check_sampling_link(plant, target)
    start_date = Date.new
    current_date = Date.today
    sampling_target = target == 'Lab' ? plant.sampling_lists.lab : plant.sampling_lists.internal
    frecuency_name = sampling_target.last.frecuency.name
    sampling_cycle = sampling_target.last.per_cycle

    case frecuency_name
    when 'Daily'    then start_date = current_date.beginning_of_day
    when 'Weekly'   then start_date = current_date.beginning_of_week
    when 'Monthly'  then start_date = current_date.at_beginning_of_month
    when 'Annualy'  then start_date = current_date.beginning_of_year
    end

    sampling_targets = sampling_target.select { |elem| elem.created_at.to_date.between?(start_date, current_date) }
    sampling_list = generate_new_sampling_lists(target) if sampling_targets.size < sampling_cycle

    sampling_param = sampling_list.blank? ? sampling_target.last : sampling_list
    edit_sampling_list_path(sampling_param)
  end

  def generate_new_sampling_lists(target)
    sampling_target = target == 'Lab' ? @plant.sampling_lists.lab : @plant.sampling_lists.internal
    plant_samplings = sampling_target.includes(:access, :samplings)
    sampling_list = plant_samplings.max_by(&:created_at)

    new_sl = SamplingList.create(plant_id: sampling_list.plant_id,
                                 access_id: sampling_list.access_id,
                                 frecuency_id: sampling_list.frecuency_id,
                                 per_cycle: sampling_list.per_cycle)

    sampling_list.samplings.each do |sampling|
      new_sl.samplings.create(standard_id: sampling.standard_id, value_in: 0.0, value_out: 0.0)
    end

    new_sl
  end

  def plant_params
    params.require(:plant).permit(
      :name, :code, :company_id, :address01, :address02, :state, :zip, :phone, :flow_design, :startup_date,
      :country_id, :discharge_point_id, :contact_id, :bf_contact_id, standards_attributes: [:id, :option_id,
        :plant_id, :isRange, :enabled, bounds_attributes: [:id, :standard_id, :outlet_id, :from, :to]],
      system_size: [], sampling_lists_attributes: [:id, :access_id, :frecuency_id, :per_cycle])
  end
end
