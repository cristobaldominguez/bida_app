class LogStandard < ApplicationRecord
  belongs_to :task
  belongs_to :plant
  has_many :current_log_standards

  accepts_nested_attributes_for :task

  def task_attributes=(attributes)
    self.task = Task.find(attributes[:id])
    super(attributes)
  end

  enum season: %i[no show hide]
end
