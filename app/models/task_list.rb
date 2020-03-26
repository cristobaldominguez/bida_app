class TaskList < ApplicationRecord
  has_many :logbooks
  belongs_to :plant

  has_many :tasks
  accepts_nested_attributes_for :tasks

  def tasks_attributes=(attributes)
    self.task = Task.find(attributes[:id])
    super(attributes)
  end

  enum season: %i[no show hide]
end
