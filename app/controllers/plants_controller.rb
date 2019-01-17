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

    @plant.sampling_lists.order(created_at: :desc).limit(2).each do |sl|
      @plant.standards.each do |stdr|
        sl.samplings.build(standard: stdr)
      end
    end

    @plant.sampling_lists.each do |sampling_list|
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

  def plant_params
    params.require(:plant).permit(
      :name, :code, :company_id, :address01, :address02, :state, :zip, :phone, :flow_design, :startup_date,
      :country_id, :discharge_point_id, :contact_id, :bf_contact_id, standards_attributes: [:id, :option_id,
        :plant_id, :isRange, :enabled, bounds_attributes: [:id, :standard_id, :outlet_id, :from, :to]],
      system_size: [], sampling_lists_attributes: [:id, :access_id, :frecuency_id, :per_cycle])
  end
end
