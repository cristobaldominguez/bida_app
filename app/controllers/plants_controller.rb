class PlantsController < ApplicationController
  before_action :set_company, only: %i[show create update destroy]
  before_action :set_companies, only: :index
  before_action :set_discharge_points, :set_countries, only: %i[new edit create update]
  before_action :set_users, :set_frecuencies, only: %i[new edit create update]
  before_action :set_responsibles, :set_season, :set_log_frecuency, :set_value_types, only: %i[new edit create update show]

  load_and_authorize_resource

  # GET companies/:company_id/plants
  # GET companies/:company_id/plants.json
  def index
    @plants = current_user.plants.active
  end

  # GET companies/:company_id/plants/1
  # GET companies/:company_id/plants/1.json
  def show
    @alerts = @plant.alerts.active
    @supports = @plant.supports.active
    @inspections = @plant.inspections.active
    # @standards = @plant.standards.includes(:option, :bounds).sort_by(&:option_id)
    @standards = @plant.standards.sort_by(&:option_id)
    @sampling_lists = @plant.sampling_lists.includes(:access, samplings: [standard: %i[option bounds]]).group_by { |k| k.access.name }.map { |_, v| v.max_by(&:created_at) }
    @samplings = @sampling_lists.map { |sl| { sl.access.name => sl.samplings.group_by { |s| s.standard.option.name }.map { |_, v| v.max_by(&:created_at) } } }
    @task_lists = @plant.task_lists.includes(:tasks)
    @graph_standards = @plant.graph_standards.includes(:chart)
    @task_list = @task_lists.last.tasks.sort

    @system_size = @plant.system_size.sum
    @volume_metric = @system_size > 1 ? @plant.country.metric.volume.pluralize : @plant.country.metric.volume
  end

  def new
    @plant = Company.find(params[:company_id]).plants.build
    @plant.country = Country.find(3)
    sampling_lists = SamplingListGenerator.new(@plant).build
    @sampling_lists_filtered = sampling_lists.select { |sampling_list| sampling_list.access.name == 'External' }
    @graph_standards = Chart.all.map { |chart| @plant.graph_standards.build(chart: chart) }

    @task_list = @plant.task_lists.build
    @task_list.tasks.build
  end

  def create
    @plant = @company.plants.build(plant_params)
    @plant.system_size = params[:plant][:system_size].split(' ').map(&:to_i)
    @plant.cover.attach(params[:plant][:cover])
    @plant.discharge_permit.attach(params[:plant][:discharge_permit]) if params[:plant][:discharge_permit].present?
    @current_date = Date.today

    external_sampling_list = @plant.sampling_lists.first
    external_sampling_list.date = @current_date.beginning_of_month

    accesses_without_external.each do |access|
      @plant.sampling_lists.build(date: external_sampling_list.date,
                                  frecuency_id: external_sampling_list.frecuency_id,
                                  access: access,
                                  per_cycle: external_sampling_list.per_cycle)
    end

    @plant.sampling_lists.each do |sampling_list|
      SamplingListGenerator.new(@plant).create(sampling_list)
    end

    @plant.users << current_user

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

  def edit
    @plant = Plant.find(params[:id])
    @company = @plant.company
    @standards = @plant.standards.includes(:option, bounds: :outlet).sort_by(&:option_id)
    @graph_standards = @plant.graph_standards.includes(:chart)
    @sampling_lists_filtered = @plant.sampling_lists.includes(:access).select { |sampling_list| sampling_list.access.name == 'External' }.last

    @task_list = @plant.task_lists.last
    @tasks = @task_list.tasks.sort
  end

  def update
    @plant.system_size = params[:plant][:system_size].split(' ').map(&:to_i)
    @plant.cover.attach(params[:plant][:cover]) if params[:plant][:cover].present?
    @plant.discharge_permit.attach(params[:plant][:discharge_permit]) if params[:plant][:discharge_permit].present?

    SamplingListGenerator.new(@plant).edit(with_params: params[:plant][:standards_attributes])

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

  def logbook
    redirect_to edit_plant_logbook_path(@plant, @plant.logbooks.last)
  end

  def self.generate_plants_logbooks
    plants = Plant.all.select(&:active)
    plants.each do |plant|
      logbook = plant.logbooks.create
      LogsController.generate_monthly_logs(logbook, Date.today)
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

  def set_value_types
    @input_types = Task.input_types.map { |key, val| [key, key] }
    @data_types = Task.data_types.map { |key, val| [key, key] }
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

  def set_season
    @seasons = Task.seasons.map { |season, _| [season, season == 'no' ? 'No' : "Yes, show it #{season.humanize.underscore}"] }
  end

  def set_log_frecuency
    @log_frecuency = Task.frecuencies.map { |frecuency| [frecuency.first.parameterize.underscore, frecuency.first.humanize] }
  end

  def generate_month_logs(logbook)
    current_date = Date.today
    days_of_month = current_date.week_split.flatten.reject(&:nil?)

    days_of_month.map { |day| log_creation(logbook, Date.new(current_date.year, current_date.month, day)) }
  end

  def log_creation(logbook, actual_date)
    new_logs = @plant.current_log_standards.map do |cls|
      log = Log.new(logbook: logbook, value: '', date: actual_date, current_log_standard: cls)
      LogCheck.new(log, actual_date).generate? ? log : nil
    end

    new_logs.reject(&:nil?)
  end

  def accesses_without_external
    Access.all.reject { |access| access.name == 'External' }
  end

  def plant_params
    params.require(:plant).permit(
      :name, :code, :company_id, :address01, :address02, :state, :zip, :phone, :flow_design, :startup_date, :system_purpose,
      :report_preface, :country_id, :discharge_point_id, :contact_id, :bf_contact_id, :cover, :discharge_permit,
      :logbook_bf_responsible_id, :logbook_bf_supervisor_id, :logbook_company_responsible_id, system_size: [],
      standards_attributes: [:id, :option_id, :plant_id, :isRange, :enabled,
                             bounds_attributes: [:id, :standard_id, :outlet_id, :from, :to, outlet_attributes: [:id]],
                             option_attributes: %i[id name],
                             samplings_attributes: %i[id active standard_id sampling_list_id value_in value_out]],
      sampling_lists_attributes: [:id, :access_id, :frecuency_id, :per_cycle,
                                  samplings_attributes: [:id, :active, :standard_id, :sampling_list_id, :value_in, :value_out,
                                                         standard_attributes: [:id, :option_id, :plant_id, :isRange, :enabled,
                                                                               option_attributes: %i[id name]]],
                                  access_attributes: %i[id name]],
      task_lists_attributes: [:id, :active, :plant_id,
                              tasks_attributes: [:id, :active, :name, :cycle, :season, :comment, :frecuency, :responsible,
                                                 :task_list_id, :input_type, :data_type,
                                                 logs_attributes: %i[id date task_id logbook_id]]],
      graph_standards_attributes: %i[id show chart_id])
  end
end
