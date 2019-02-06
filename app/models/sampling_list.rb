class SamplingList < ApplicationRecord
  belongs_to :plant, optional: true
  belongs_to :access
  belongs_to :frecuency

  has_many :samplings

  scope :lab,      -> { where(access_id: Access.find_by(name: 'Lab').id) }
  scope :internal, -> { where(access_id: Access.find_by(name: 'Internal').id) }

  accepts_nested_attributes_for :samplings, allow_destroy: true

  # validates :per_cycle, numericality: { greater_than_or_equal_to: 1, less_than: 365 }
end
