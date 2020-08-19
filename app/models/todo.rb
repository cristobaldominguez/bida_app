# == Schema Information
#
# Table name: todos
#
#  id             :bigint           not null, primary key
#  active         :boolean          default(TRUE), not null
#  completed      :boolean          default(FALSE), not null
#  deadline       :date
#  description    :text
#  detail         :jsonb
#  label          :integer          default("red"), not null
#  sort           :integer          default(1)
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  created_by_id  :integer
#  plant_id       :bigint
#  responsible_id :integer          not null
#
# Indexes
#
#  index_todos_on_detail    (detail) USING gin
#  index_todos_on_plant_id  (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (plant_id => plants.id)

class Todo < ApplicationRecord
  belongs_to :plant
  belongs_to :responsible, class_name: 'User'
  belongs_to :created_by, class_name: 'User'

  serialize :detail

  has_many_attached :images

  scope :created_or_responsible, ->(current_user) { where(created_by: current_user).or(where(responsible: current_user)) }
  scope :executed_by, ->(current_user) { where(responsible: current_user) }
  scope :undone, -> { where completed: false }
  scope :done, -> { where completed: true }
  scope :done_today, -> { where 'deadline < ?', Date.today }
  scope :to_be_done, -> { where 'deadline > ? AND completed IS false', Date.today - 7.days }

  enum label: %i[red orange yellow green blue purple]
end
