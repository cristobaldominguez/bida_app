class LogbooksController < ApplicationController
  before_action :set_date, only: %i[create new edit update show]
  after_action :generate_month_logs, only: :create
  load_and_authorize_resource

  # GET /logbooks
  # GET /logbooks.json
  def index
    @logbooks = @plant.logbooks.active
  end

  # GET /logbooks/1
  # GET /logbooks/1.json
  def show
    # @logbooks.includes(:log_standard)
    @filtered_logs = @logbook.logs.includes(current_log_standard: [:log_standard]).order('date DESC').reject { |log| log.date > @current_date }
  end

  # GET plants/1/logbooks/new
  def new
    @logbook = Logbook.new
    @logbook.plant = Plant.find(params[:plant_id])

    current_log_standards = @logbook.plant.current_log_standards.includes(log_standard: [:task])

    current_log_standards.each do |cls|
      @logbook.logs.build(current_log_standard: cls, date: @current_date)
    end

    # @filtered_logs = @logbook.logs.select { |log| log.date == @current_date }
    @filtered_logs = @logbook.logs
  end

  # POST /logbooks
  # POST /logbooks.json
  def create
    @logbook = Logbook.new(logbook_params)
    @logbook.plant = Plant.find(params[:plant_id])

    @logbook.logs = []
    logs_params = params[:logbook][:logs_attributes]
    logs_params.each do |current_log|
      log = current_log.second
      @logbook.logs.build(value: log['value'], date: @current_date, current_log_standard_id: log['current_log_standard_attributes']['id'])
    end

    respond_to do |format|
      if @logbook.save
        format.html { redirect_to edit_plant_logbook_path(@plant, @logbook), notice: 'Logbook was successfully created.' }
        format.json { render :show, status: :created, location: @logbook }
      else
        format.html { render :new }
        format.json { render json: @logbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /logbooks/1/edit
  def edit
    @plant = @logbook.plant
    logs = @logbook.logs.includes(current_log_standard: [log_standard: [:task]]).order('date DESC')
    cls = @plant.current_log_standards.includes(:log_standard)

    lgs = LogbookProcessor.new(logs, cls).valid_logs(current_user)

    @filtered_logs = lgs.sort_by(&:date).reverse
  end

  # PATCH/PUT /logbooks/1
  # PATCH/PUT /logbooks/1.json
  def update
    @logbook.logs = @logbook.logs.map do |log|
      log.value = '' if (log.value == '0' || log.value.nil?) && log.current_log_standard.log_standard.task.checkbox?
      log
    end

    respond_to do |format|
      if @logbook.update(logbook_params)
        format.html { redirect_to edit_plant_logbook_path(@plant, @logbook), notice: 'Logbook was successfully updated.' }
        format.json { render :show, status: :ok, location: @logbook }
      else
        format.html { render :edit }
        format.json { render json: @logbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logbooks/1
  # DELETE /logbooks/1.json
  def destroy
    @logbook.inactive!
    respond_to do |format|
      format.html { redirect_to plant_logbooks_path(@logbook.plant), notice: 'Logbook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def current_logs(logs, date)
    logs.select { |log| log.date == date }
  end

  def previous_logs(logs, date)
    logs.select { |log| log.date < date && log.value.blank? }
  end

  def check_date
    # the_date = Date.new(@logbook.created_at.year, @logbook.created_at.month, 1)
    # @current_date == the_date ? @current_date : the_date.end_of_month
    @current_date
  end

  def set_date
    @current_date = Date.today
  end

  def generate_month_logs
    days_of_month = @current_date.week_split.flatten.reject(&:nil?).reject { |day| day == @current_date.day }
    logs = days_of_month.map { |day| log_creation(@logbook, Date.new(@current_date.year, @current_date.month, day)) }

    @logbook.logs << logs.reject(&:nil?)
  end

  def log_creation(logbook, actual_date)
    new_logs = logbook.logs.map do |log|
      Log.new(logbook_id: logbook.id, value: nil, date: actual_date, current_log_standard_id: log.current_log_standard.id) if LogCheck.new(log, actual_date).valid?
    end

    new_logs.reject(&:nil?)
  end

  def logbook_params
    params.require(:logbook).permit(:id, :plant_id, logs_attributes: [:id, :logbook_id, :active, :value, :document, :date,
                                    current_log_standard_attributes: [:frecuency, :cycle, :plant_id,
                                      log_standard_attributes: [:season, :responsible, :comment, :name, :plant_id, :active, :task_id, task_attributes:[:id]]]])
  end
end
