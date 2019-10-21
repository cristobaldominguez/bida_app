class LogsController < ApplicationController
  def self.generate_monthly_logs(logbook, current_date)
    days_of_month = current_date.week_split.flatten.reject(&:nil?)
    logs = days_of_month.map { |day| log_creation(logbook, Date.new(current_date.year, current_date.month, day)) }
    logs.flatten.map(&:save)
  end

  def self.log_creation(logbook, actual_date)
    current_log_standards = logbook.plant.current_log_standards.includes(log_standard: %i[task plant])
    new_logs = current_log_standards.map do |cls|
      log = Log.new(logbook: logbook, value: '', date: actual_date, current_log_standard: cls)
      LogCheck.new(log, actual_date).generate? ? log : nil
    end

    new_logs.reject(&:nil?)
  end
end
