class LogsController < ApplicationController
  def self.generate_monthly_logs(logbook, current_date)
    days_of_month = current_date.week_split.flatten.reject(&:nil?)
    logs = days_of_month.map { |day| log_creation(logbook, Date.new(current_date.year, current_date.month, day)) }
    logs.flatten.map(&:save)
  end

  def self.log_creation(logbook, actual_date)
    tasks = logbook.plant.task_lists.last.tasks
    new_logs = tasks.map do |task|
      log = Log.new(logbook: logbook, value: '', date: actual_date, task: task)
      LogCheck.new(log, actual_date).generate? ? log : nil
    end

    new_logs.reject(&:nil?)
  end
end
