class Processing::Logbook
  def self.get_logs_from(logbook, current_user)
    @plant = logbook.plant
    @current_user = current_user
    @responsibles_ids = (@plant.users.all_operations_managers.pluck(:id) + [ current_user.id ]).uniq

    tasks_ids = logbook.task_list.tasks.pluck(:id)
    @from_db = Log.includes(task: :task_list).where(task_id: tasks_ids).active.until_date(Date.today.next).last_of_every_task

    validate_logs_from_db
  end

  private

  def self.validate_logs_from_db
    @from_db.select {|log| valid_log?(log) }
  end

  def self.valid_log?(log)
    return false if log.date.nil?
    return false if log.value.present?
    return false if is_cross_season?(log.task)
    return false unless employee_can_execute?(@current_user)

    log
  end

  def self.is_cross_season?(cls)
    @plant.high_season && cls.out_season? || !@plant.high_season && cls.in_season?
  end

  def self.employee_can_execute?(current_user)
    return true if current_user.admin? # Todos los administradores podran ver todos los Logs
    return true if is_in_charge?(current_user) # Se revisa si es el encargado directo o el gerente de operaciones de la planta

    current_task = @task.responsible.zero? # Si responsible == 0, la empresa se hace responsable. responsible == -1 se hace responsable Biofiltro
    current_task && current_user.company? || !current_task && current_user.biofiltro?
  end

  def self.is_in_charge?(current_user)
    @responsibles_ids.include? @task.responsible
  end
end
