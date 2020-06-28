class GeneratePlantsLogbooksJob < ApplicationJob
  queue_as :default

  def perform
    plants = Plant.active.sort
    plants.each do |plant|
      task_list = plant.task_lists.active.last
      logbook = plant.logbooks.create(task_list: task_list)

      LogsController.generate_monthly_logs(logbook, Date.today)
    end
  end
end
