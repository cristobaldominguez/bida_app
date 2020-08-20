class TodoDailyNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    TodosController.daily_mailing
  end
end
