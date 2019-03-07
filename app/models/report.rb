class Report < ApplicationRecord
  belongs_to :plant

  enum state: %i[draft published]

  scope :created_between, ->(start_date, end_date) { where('created_at BETWEEN ? AND ?', start_date, end_date) }
end
