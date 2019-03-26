class LogbooksController < ApplicationController
  before_action :set_date, only: [:edit, :new]
  load_and_authorize_resource

  # GET /logbooks
  # GET /logbooks.json
  def index
    @logbooks = Logbook.all
  end

  # GET /logbooks/1
  # GET /logbooks/1.json
  def show
    # @logbooks.includes(:log_standard)
    @logs = @logbook.logs.includes(log_standard: [:frecuency, task: [:log_type, :input_type]]).order('log_types.id')
  end

  # GET plants/1/logbooks/new
  def new
    @logbook = Logbook.new
    @logbook.plant = Plant.find(params[:plant_id])
    log_standards = @logbook.plant.log_standards.includes(:frecuency, task: [:log_type, :input_type])

    log_standards.each do |log_standard|
      @logbook.logs.build(log_standard: log_standard)
    end

    # @strds = @logbook.plant.log_standards.includes(:frecuency, task: :input_type)
    @logs = @logbook.logs
  end

  # POST /logbooks
  # POST /logbooks.json
  def create
    @logbook = Logbook.new(logbook_params)

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
    current_date = Date.today
    logs = @logbook.logs.includes(log_standard: [:frecuency, task: %i[input_type log_type]])
    @logs = logs.order(:id).to_a

    display_logs = logs.map do |log|
      frecuency_name = log.log_standard.frecuency.name
      start_date = def_start_date(frecuency_name)

      selected_logs = logs.select { |elem| elem.log_standard == log.log_standard }.select { |elem| elem.created_at.to_date.between?(start_date, current_date) }
      desition = create_new_log?(selected_logs, log)
      desition ? logs.build(log_standard_id: log.log_standard_id) : log
    end

    @logs = display_logs.sort_by { |log| log.log_standard.task.log_type.name }
  end

  # PATCH/PUT /logbooks/1
  # PATCH/PUT /logbooks/1.json
  def update
    params[:logbook][:logs_attributes].each do |key, parameter|
      if parameter[:id].nil? && (parameter[:value].blank? || parameter[:log_standard_attributes][:task_attributes][:input_type][:option] == 'checkbox')
        @logbook.logs.create(log_standard_id: parameter[:log_standard_attributes][:id].to_i, value: parameter[:value])
        params[:logbook][:logs_attributes].extract!(key)
      end
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
    @logbook.active = false
    @logbook.save
    respond_to do |format|
      format.html { redirect_to logbooks_url, notice: 'Logbook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_date
    @today = Date.today
  end

  def create_logs(logbook)
    logs = []
    log_standards = logbook.plant.log_standards.includes(:frecuency, task: :input_type)

    log_standards.each do |log_standard|
      logs << logbook.logs.build(log_standard: log_standard)
    end

    logs
  end

  def def_start_date(frecuency_name)
    start_date = Date.new
    current_date = Date.today
    case frecuency_name
    when 'Daily'    then start_date = current_date.beginning_of_day
    when 'Weekly'   then start_date = current_date.beginning_of_week
    when 'Monthly'  then start_date = current_date.at_beginning_of_month
    when 'Annualy'  then start_date = current_date.beginning_of_year
    end

    start_date
  end

  def create_new_log?(logs, log)
    cycle_quantity = log.log_standard.cycle

    return true if logs.size.zero? && logs.size < cycle_quantity

    last_log_value = logs.last.value
    last_log_type = logs.last.log_standard.task.input_type.option

    (logs.size < cycle_quantity) && (last_log_value.blank? || (last_log_type == 'checkbox' && last_log_value == '0'))
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def logbook_params
    params.require(:logbook).permit(:id, :plant_id, logs_attributes: [:id, :logbook, :active, :value,
      log_standard_attributes: [:id, :frecuency_id, :active, :responsible, :cycle,
        task_attributes: [:id, :log_type_id, :input_type_id, :frecuency_id, :cycle, :responsible, :active, :name]]])
  end
end
