class Processing::Logbook
  def self.get_logs_from(plant, current_user)
    @plant = plant
    @current_user = current_user
    @responsibles_ids = (@plant.users.all_operations_managers.pluck(:id) + [current_user.id]).uniq

    tasks_ids = @plant.task_lists.last.tasks.pluck(:id)
    logbooks = @plant.logbooks.pluck(:id)
    @from_db = ::Log.includes(task: :task_list).where(task_id: tasks_ids).where(logbook_id: logbooks).active.until_date(Date.today.next).last_of_every_task

    validate_logs_from_db
  end

  def self.validate_logs_from_db
    @from_db.select { |log| valid_log?(log) }
  end

  def self.valid_log?(log)
    @task = log.task

    return false if log.date.nil?
    return false if log.value.present?
    return false if cross_season?
    return false unless employee_can_execute?

    log
  end

  def self.cross_season?
    @plant.high_season && @task.out_season? || !@plant.high_season && @task.in_season?
  end

  def self.employee_can_execute?
    return true if @current_user.admin? # Todos los administradores podran ver todos los Logs
    return true if in_charge? # Se revisa si es el encargado directo o el gerente de operaciones de la planta

    current_task = @task.responsible.zero? # Si responsible == 0, la empresa se hace responsable. responsible == -1 se hace responsable Biofiltro
    current_task && @current_user.company? || !current_task && @current_user.biofiltro?
  end

  def self.in_charge?
    @responsibles_ids.include? @task.responsible
  end
end
