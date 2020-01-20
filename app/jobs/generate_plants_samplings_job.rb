class GeneratePlantsSamplingsJob < ApplicationJob
  queue_as :default

  def perform
    plants = Plant.all.active
    accesses = Access.all

    accesses.each do |access|
      plants.each do |plant|
        SamplingListsController.api_new(plant, access.name, {}, Date.today.beginning_of_month)
      end
    end
  end
end
