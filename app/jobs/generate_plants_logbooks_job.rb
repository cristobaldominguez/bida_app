class GeneratePlantsLogbooksJob < ApplicationJob
  queue_as :default

  def perform
    Plant.active.sort.map do |plant|
      plant.logbooks.create(task_list: plant.task_lists.active.last)
    end
  end
end
