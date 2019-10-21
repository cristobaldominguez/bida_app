class GenerateLogsJob < ApplicationJob
  queue_as :urgent

  def perform(logbook, current_date = Date.today)
    LogsController.generate_monthly_logs(logbook, current_date)
  end
end
