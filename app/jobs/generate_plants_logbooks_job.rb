class GeneratePlantsLogbooksJob < ApplicationJob
  queue_as :urgent

  def perform
    PlantsController.generate_plants_logbooks
  end
end
