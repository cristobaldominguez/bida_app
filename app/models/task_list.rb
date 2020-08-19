# == Schema Information
#
# Table name: task_lists
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plant_id   :bigint
#
# Indexes
#
#  index_task_lists_on_plant_id  (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (plant_id => plants.id)

class TaskList < ApplicationRecord
  has_many :logbooks
  belongs_to :plant

  has_many :tasks
  accepts_nested_attributes_for :tasks

  scope :active, -> { where(active: true) }

  enum season: %i[no show hide]
end
