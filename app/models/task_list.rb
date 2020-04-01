class TaskList < ApplicationRecord
  has_many :logbooks
  belongs_to :plant

  has_many :tasks
  accepts_nested_attributes_for :tasks

  enum season: %i[no show hide]
end
