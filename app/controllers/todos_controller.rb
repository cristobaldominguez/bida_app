class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy delete_image]
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
    @biofiltro_users = User.active.filtered_by(@plant).from_biofiltro.sort
  end

  def edit
    @biofiltro_users = User.active.filtered_by(@plant).from_biofiltro.sort
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

  def delete_image
    @image = ActiveStorage::Attachment.find(params[:image_id])
    @image.purge

    respond_to do |format|
      format.js { render :delete_image, status: :ok }
    end
  end

  def completed
    @todo = Todo.find(params[:id])
    @todo.completed = ActiveModel::Type::Boolean.new.cast(params[:value])
    @todo.save

    respond_to do |format|
      format.json { render json: {id: @todo.id}, status: :ok }
    end
  end

  def self.daily_mailing
    created_today_todos = Todo.where("created_at > ? ", Date.today - 24.hours)
    about_to_expire_todos = Todo.where(deadline: Date.tomorrow).where(completed: false)

    to_expire_users_todos = created_today_todos.pluck(:responsible_id, :created_by_id).flatten.uniq
    users_with_tomorrow_deadlines_todos = about_to_expire_todos.pluck(:responsible_id, :created_by_id).flatten.uniq

    users_ids = (to_expire_users_todos + users_with_tomorrow_deadlines_todos).flatten.uniq.sort
    return if users_ids.blank?

    users_todos = {}
    users_ids.map do |user_id|
      users_todos[user_id] = {}
      users_todos[user_id][:assignated] = created_today_todos.where(responsible_id: user_id).to_a
      users_todos[user_id][:created] = created_today_todos.where(created_by_id: user_id).to_a
      users_todos[user_id][:to_expire] = about_to_expire_todos.where(created_by_id: user_id).to_a
    end

    users = User.where(id: users_ids).sort
    users_todos.each do |key, todos|
      user = users.find { |u| u.id == key }
      NotificationMailer.todos_notification(user, todos).deliver_later
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
    params.require(:todo).permit(:title, :description, :completed, :label, :deadline, :responsible_id, images: [], detail: {})
  end
end
