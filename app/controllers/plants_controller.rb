class PlantsController < ApplicationController
  before_action :set_company, only: %i[show create update destroy]
  before_action :set_companies, only: :index
  before_action :set_discharge_points, :set_countries, only: %i[new edit create update]
  before_action :set_users, :set_frecuencies, only: %i[new edit create update]
  before_action :set_responsibles, :set_season, :set_log_frecuency, only: %i[new edit create update show]

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
    @log_standards = @plant.log_standards.includes(:frecuency, :task)
    @graph_standards = @plant.graph_standards.includes(:chart)
    @current_log_standards = @plant.current_log_standards.includes(:log_standard)

    @system_size = @plant.system_size.sum
    @volume_metric = @system_size > 1 ? @plant.country.metric.volume.pluralize : @plant.country.metric.volume
  end

  # GET companies/:company_id/plants/new
  def new
    @company = Company.find(params[:company_id])
    @plant = @company.plants.build
    @plant.country = Country.find(3)
    sampling_lists = SamplingListGenerator.new(@plant).build
    @sampling_lists_filtered = sampling_lists.select { |sampling_list| sampling_list.access.name == 'External' }
    @graph_standards = Chart.all.map { |chart| @plant.graph_standards.build(chart: chart) }

    log_standards = Task.all.order(:id).map { |task| @plant.log_standards.build(task: task, name: task[:name], season: task[:season], comment: task[:comment], responsible: task[:responsible]) }
    @current_log_standards = log_standards.map { |log_standard| @plant.current_log_standards.build(plant: @plant, log_standard: log_standard, frecuency: log_standard.task.frecuency, cycle: log_standard.task.cycle) }
  end

  # POST companies/:company_id/plants
  # POST companies/:company_id/plants.json
  def create
    @plant = @company.plants.build(plant_params)
    @plant.system_size = params[:plant][:system_size].split(' ').map(&:to_i)
    @plant.cover.attach(params[:plant][:cover])
    @plant.discharge_permit.attach(params[:plant][:discharge_permit]) if params[:plant][:discharge_permit].present?
    @logbook = @plant.logbooks.build
    @current_date = Date.today

    @plant.sampling_lists.each do |sampling_list|
      sampling_list.date = @current_date.beginning_of_month
      SamplingListGenerator.new(@plant).create(sampling_list)
    end

    @plant.current_log_standards = []
    cls_params = params['plant']['current_log_standards_attributes']

    cls_params.each do |cls|
      ls = cls.second['log_standard_attributes']
      log_standard = @plant.log_standards.build(name: ls['name'],
                                                active: ls['active'],
                                                task_id: ls['task_id'],
                                                comment: ls['comment'],
                                                season: ls['season'],
                                                responsible: ls['responsible'])
      @plant.current_log_standards.build(log_standard: log_standard, frecuency: cls.second['frecuency'], cycle: cls.second['cycle'])
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

  # GET companies/:company_id/plants/1/edit
  def edit
    @plant = Plant.find(params[:id])
    @company = @plant.company
    standards = @plant.standards.includes(:option, bounds: :outlet)
    # sampling_lists = @plant.sampling_lists.includes(:access, :samplings)
    sampling_lists = @plant.sampling_lists.includes(:access)
    @current_log_standards = @plant.current_log_standards.includes(log_standard: :task)

    build_samplings(sampling_lists, standards)
    @samplings = sampling_lists.group_by(&:access_id).map { |_, k| k.max_by(&:created_at) }
    @graph_standards = @plant.graph_standards.includes(:chart)
  end

  # PATCH/PUT companies/:company_id/plants/1
  # PATCH/PUT companies/:company_id/plants/1.json
  def update
    @plant.system_size = params[:plant][:system_size].split(' ').map(&:to_i)
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
    @seasons = Task.seasons.map { |season, _| [season, "#{'Yes, ' unless season == 'no'}#{season.to_s.capitalize}#{' it' unless season == 'no'}"] }
  end

  def set_log_frecuency
    @log_frecuency = CurrentLogStandard.frecuencies.map { |frecuency| [frecuency.first.parameterize.underscore, frecuency.first.humanize] }
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

  def plant_params
    params.require(:plant).permit(
      :name, :code, :company_id, :address01, :address02, :state, :zip, :phone, :flow_design, :startup_date, :system_purpose,
      :report_preface, :country_id, :discharge_point_id, :contact_id, :bf_contact_id, :cover, :discharge_permit,
      :logbook_bf_responsible_id, :logbook_bf_supervisor_id, :logbook_company_responsible_id, system_size: [],
      standards_attributes: [:id, :option_id, :plant_id, :isRange, :enabled,
        bounds_attributes: [:id, :standard_id, :outlet_id, :from, :to,
          outlet_attributes: [:id]],
        option_attributes: [:id, :name],
        samplings_attributes: [:id, :active, :standard_id, :sampling_list_id, :value_in, :value_out]],
      sampling_lists_attributes: [:id, :access_id, :frecuency_id, :per_cycle,
        samplings_attributes: [:id, :active, :standard_id, :sampling_list_id, :value_in, :value_out,
          standard_attributes: [:id, :option_id, :plant_id, :isRange, :enabled,
            option_attributes: [:id, :name]]],
        access_attributes: [:id, :name]],
      current_log_standards_attributes: [:id, :cycle, :frecuency, :log_standard_id, :plant_id,
        log_standard_attributes: [:id, :active, :season, :responsible, :comment, :name, :task_id, :plant_id,
          task_attributes: [:id]]],
      graph_standards_attributes: [:id, :show, :chart_id])
  end
end
