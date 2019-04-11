class Report < ApplicationRecord
  belongs_to :plant

  has_many :graphs

  enum state: %i[draft published]

  scope :created_between, ->(start_date, end_date) { where('date BETWEEN ? AND ?', start_date, end_date) }

  accepts_nested_attributes_for :graphs, allow_destroy: true
end
