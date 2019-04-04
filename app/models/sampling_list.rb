class SamplingList < ApplicationRecord
  belongs_to :plant, optional: true
  belongs_to :access
  belongs_to :frecuency

  has_many :samplings

  scope :lab,      -> { where(access_id: Access.find_by(name: 'Lab').id) }
  scope :internal, -> { where(access_id: Access.find_by(name: 'Internal').id) }

  scope :created_between, ->(start_date, end_date) { where('sampling_lists.created_at BETWEEN ? and ?', start_date, end_date) }
  scope :created_before, ->(end_date) { where('sampling_lists.created_at < ?', end_date) }

  accepts_nested_attributes_for :samplings, allow_destroy: true

  # validates :per_cycle, numericality: { greater_than_or_equal_to: 1, less_than: 365 }
end
