class GenerateSamplingsJob < ApplicationJob
  queue_as :default

  def perform(plant)
    accesses = Access.all
    accesses.each do |access|
      SamplingListsController.api_new(plant, access.name, {}, Date.today.beginning_of_month)
    end
  end
end
