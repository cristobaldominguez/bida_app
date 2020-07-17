class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy]
  before_action :set_labels, only: %i[new create edit update]

  def index
    @todos = {}
    @todos[:undone] = {}
    Todo.active.undone.created_or_responsible(current_user).group_by(&:label).map { |key, val| @todos[:undone][key.to_sym] = val.sort_by(&:sort) if val.present? }
    @todos[:done] = Todo.active.done.created_or_responsible(current_user).limit(20).sort_by(&:deadline).reverse
    @labels = Todo.labels.keys.map(&:to_sym)
  end

  def show; end

  def new
    @todo = Todo.new
    @biofiltro_users = User.filtered_by(@plant).from_biofiltro.sort
  end

  def edit
    @biofiltro_users = User.filtered_by(@plant).from_biofiltro.sort
  end

  def create
    @todo = Todo.new(todo_params.merge(created_by: current_user, plant_id: params[:plant_id]))

    respond_to do |format|
      if @todo.save
        format.html { redirect_to [@plant, @todo], notice: t(:successfully_created, scope: :todo) }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to [@plant, @todo], notice: t(:successfully_updated, scope: :todo) }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo.inactive!
    respond_to do |format|
      format.html { redirect_to plant_todos_path(@plant), notice: t(:successfully_deleted, scope: :todo) }
      format.json { head :no_content }
    end
  end

  private

  def set_labels
    @labels = Todo.labels.map { |key, _| [key, key] }
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed, :label, :deadline, :responsible_id, detail: {})
  end
end
