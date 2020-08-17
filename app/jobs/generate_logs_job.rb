class GenerateLogsJob < ApplicationJob
  queue_as :default

  def perform(logbook)
    LogsController.generate_monthly_logs(logbook)
  end
end
