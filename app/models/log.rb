class Log < ApplicationRecord
  belongs_to :logbook
  belongs_to :task

  accepts_nested_attributes_for :task

  has_one_attached :document
  scope :active, -> { where(active: true) }
  scope :no_value, -> { where(value: '') }
  scope :updated_between, ->(start_date, end_date) { where('updated_at BETWEEN ? AND ?', start_date, end_date) }
  scope :date_between, ->(start_date, end_date) { where('date BETWEEN ? AND ?', start_date, end_date) }
  scope :until_date, ->(end_date) { where('date < ?', end_date) }
  scope :last_of_every_task, -> { select('DISTINCT ON ("task_id") *').order(:task_id, date: :desc, id: :desc) }
end
