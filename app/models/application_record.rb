class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  serialize :system_size, Array

  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }
  scope :sort_by_id, -> { order('id ASC') }
  scope :created_between, ->(start_date, end_date) { where('date BETWEEN ? AND ?', start_date, end_date) }

  def inactive!
    self.active = false
    self.save
  end
end
