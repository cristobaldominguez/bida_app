class Log < ApplicationRecord
  belongs_to :logbook
  belongs_to :current_log_standard
  accepts_nested_attributes_for :current_log_standard

  has_one_attached :document
  scope :updated_between, ->(start_date, end_date) { where('updated_at BETWEEN ? AND ?', start_date, end_date) }
end
