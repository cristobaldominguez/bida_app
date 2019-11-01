class GeneratePlantsLogbooksJob < ApplicationJob
  queue_as :default

  def perform
    plants = Plant.all.select(&:active)
    plants.each do |plant|
      logbook = plant.logbooks.create
      LogsController.generate_monthly_logs(logbook, Date.today)
    end
  end
end
