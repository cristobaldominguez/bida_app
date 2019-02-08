class Log < ApplicationRecord
  belongs_to :logbook
  belongs_to :log_standard

  scope :updated_between, ->(start_date, end_date) { where('updated_at BETWEEN ? AND ?', start_date, end_date) }

  accepts_nested_attributes_for :log_standard
end
