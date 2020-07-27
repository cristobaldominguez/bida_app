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
  scope :done_in_future, -> { where 'deadline > ?', Date.today }

  enum label: %i[red orange yellow green blue purple]
end
