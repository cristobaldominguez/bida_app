class PlantsController < ApplicationController
  before_action :set_company, only: %i[show create update destroy]
  before_action :set_companies, only: :index
  before_action :set_discharge_points, :set_countries, only: %i[new edit create update]
  before_action :set_users, :set_frecuencies, only: %i[new edit create update]
  before_action :set_responsibles, only: %i[new edit create update show]
  after_action :assign_plant_to_current_user, only: :create, unless: -> { @plant.nil? }
  load_and_authorize_resource

  # GET companies/:company_id/plants
  # GET companies/:company_id/plants.json
  def index
    # @plants = Company.find(params[:company_id]).plants.active
    # @company = Company.find(params[:company_id])
    @plants = current_user.plants.active
  end

  # GET companies/:company_id/plants/1
  # GET companies/:company_id/plants/1.json
  def show
    @alerts = @plant.alerts.active
    @supports = @plant.supports.active
    @inspections = @plant.inspections.active
    @standards = @plant.standards
    @sampling_lists = @plant.sampling_lists.includes(:access, samplings: [standard: %i[option bounds]]).group_by { |k| k.access.name }.map { |_, v| v.max_by(&:created_at) }
    @samplings = @sampling_lists.map { |sl| { sl.access.name => sl.samplings.group_by { |s| s.standard.option.name }.map { |_, v| v.max_by(&:created_at) } } }
    @log_standards = @plant.log_standards.includes(:frecuency, task: :log_type).order('log_types.id')
    @graph_standards = @plant.graph_standards.includes(:chart)

    @system_size = @plant.system_size.sum
    @volume_metric = @system_size > 1 ? @plant.country.metric.volume.pluralize : @plant.country.metric.volume
  end

  # GET companies/:company_id/plants/new
  def new
    @company = Company.find(params[:company_id])
    @plant = @company.plants.build
    @is_new = true

    @frecuencies = Frecuency.all
    outlets = Outlet.all
    options = Option.all
    accesses = Access.all
    tasks = Task.all.order(:id).includes(:log_type)
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

    tasks.each do |task|
      @plant.log_standards.build(task: task, comment: task[:comment], frecuency_id: task[:frecuency_id], cycle: task[:cycle], responsible: task[:responsible])
    end

    charts = Chart.all
    charts.each do |chart|
      @plant.graph_standards.build(chart: chart)
    end

    @graph_standards = @plant.graph_standards
  end

  # POST companies/:company_id/plants
  # POST companies/:company_id/plants.json
  def create
    @plant = @company.plants.build(plant_params)
    @plant.system_size = params[:plant][:system_size].split(' ').map(&:to_i)

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

    logbook = @plant.logbooks.build

    @plant.log_standards.each do |log_standard|
      log_standard.logs.build(logbook: logbook)
      log_standard.save
    end

    @plant.cover.attach(params[:plant][:cover])
    @plant.discharge_permit.attach(params[:plant][:discharge_permit]) if params[:plant][:discharge_permit].present?

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
    standards = @plant.standards.includes(:option, bounds: :outlet)
    # sampling_lists = @plant.sampling_lists.includes(:access, :samplings)
    sampling_lists = @plant.sampling_lists
    @log_standards = @plant.log_standards.includes(task: [:log_type]).order('log_types.id')

    build_samplings(sampling_lists, standards)
    @samplings = sampling_lists.group_by(&:access_id).map { |_, k| k.max_by(&:created_at) }
    @graph_standards = @plant.graph_standards.includes(:chart)
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

    @plant.cover.attach(params[:plant][:cover]) if params[:plant][:cover].present?
    @plant.discharge_permit.attach(params[:plant][:discharge_permit]) if params[:plant][:discharge_permit].present?

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
    @plant.inactive!
    respond_to do |format|
      format.html { redirect_to company_path(@company), notice: 'Plant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def highseason
    high_season = params[:state] == 'true'
    @plant.high_season = high_season
    @plant.save
    respond_to do |format|
      format.json { render json: { className: high_season } }
    end
  end

  private

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
    @users = User.active.sort_by_id
  end

  def set_frecuencies
    @frecuencies = Frecuency.all
  end

  def set_responsibles
    @company = params[:company_id].present? ? Company.find(params[:company_id]) : Plant.find(params[:id]).company
    @responsibles = [[0, @company.name], [1, 'BioFiltro']]
  end

  def build_samplings(sampling_lists, standards)
    sampling_lists.each do |sampling_list|
      standards.each do |standard|
        # N+1
        sampling_list.samplings.find_or_initialize_by(standard: standard)
      end
    end
  end

  def assign_plant_to_current_user
    current_user.plants << @plant
  end

  def plant_params
    params.require(:plant).permit(
      :name, :code, :company_id, :address01, :address02, :state, :zip, :phone, :flow_design, :startup_date,
      :system_purpose, :report_preface, :country_id, :discharge_point_id, :contact_id, :bf_contact_id, :cover,
      :discharge_permit, :logbook_bf_responsible_id, :logbook_bf_supervisor_id, :logbook_company_responsible_id,
      system_size: [], standards_attributes: [:id, :option_id, :plant_id, :isRange, :enabled,
        bounds_attributes: [:id, :standard_id, :outlet_id, :from, :to]], sampling_lists_attributes: [:id, :access_id,
        :frecuency_id, :per_cycle], log_standards_attributes: [:id, :task_id, :plant_id, :active, :responsible,
        :cycle, :frecuency_id, :comment], graph_standards_attributes: [:id, :show, :chart_id])
  end
end
