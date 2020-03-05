class SamplingList < ApplicationRecord
  belongs_to :plant, optional: true
  belongs_to :access
  belongs_to :frecuency

  has_many :samplings

  scope :lab,      -> { where(access_id: Access.find_by(name: 'Lab').id) }
  scope :internal, -> { where(access_id: Access.find_by(name: 'Internal').id) }

  scope :created_between, ->(start_date, end_date) { where('sampling_lists.created_at BETWEEN ? and ?', start_date, end_date) }
  scope :created_before, ->(end_date) { where('sampling_lists.date < ?', end_date) }

  accepts_nested_attributes_for :samplings, allow_destroy: true
  accepts_nested_attributes_for :access

  # validates :per_cycle, numericality: { greater_than_or_equal_to: 1, less_than: 365 }

  def lab?
    access.name == 'Lab'
  def access_attributes=(attributes)
    self.access = Access.find(attributes[:id])
    super(attributes)
  end

  end

  def internal?
    access.name == 'Internal'
  end
end
