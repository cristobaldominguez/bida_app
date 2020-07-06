class TasksController < ApplicationController
  before_action :set_variables, only: [:new, :create, :edit, :update]
  before_action :set_responsibles, only: [:index, :edit, :new]
  load_and_authorize_resource

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.active.sort_by_id
    # @tasks = Task.includes(:log_type).group_by { |task| task.log_type.id }
    # @log_types = LogType.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.inactive!
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def defaults
    @tasks = Generator::Task.defaults(params[:lang])

    respond_to do |f|
      f.json { render json: @tasks, status: :ok }
    end
  end

  private

  def set_variables
    @log_types = LogType.all
    @input_types = InputType.all
    @frecuencies = Frecuency.all
  end

  def set_responsibles
    @responsibles = [[0, 'Company'], [1, 'BioFiltro']]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:id, :log_type_id, :input_type_id, :name, :responsible, :cycle, :frecuency_id)
  end
end
