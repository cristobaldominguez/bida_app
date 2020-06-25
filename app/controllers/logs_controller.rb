class LogsController < ApplicationController
  def self.generate_monthly_logs(logbook, current_date)
    days_of_month = current_date.week_split.flatten.reject(&:nil?)
    logs = days_of_month.map { |day| log_creation(logbook, Date.new(current_date.year, current_date.month, day)) }

    logs.flatten.map(&:save)
  end

  def self.log_creation(logbook, actual_date)
    tasks = logbook.task_list.tasks

    generate_log(tasks, logbook, actual_date).reject(&:nil?)
  end

  def self.generate_log(tasks, logbook, actual_date)
    tasks.map do |task|
      log = Log.new(logbook: logbook, value: '', date: actual_date, task: task)
      LogCheck.new(log, actual_date).generate? ? log : nil
    end
  end

  # Genera tasks a partir de un array de Tasks
  def self.generate_logs(tasks, logbook, current_date)
    @@tasks = tasks
    @@logbook = logbook
    days_of_month = current_date.week_split.flatten.reject(&:nil?)

    logs = days_of_month.map { |day| log_creation_from_task(tasks, Date.new(current_date.year, current_date.month, day)) }
    logs.flatten.map(&:save)
  end

  def self.log_creation_from_task(tasks, actual_date)
    new_logs = tasks.map do |task|
      log = generate_log(tasks, @@logbook, actual_date).reject(&:nil?)
    end
  end
end
