class SamplingList < ApplicationRecord
  belongs_to :plant, optional: true
  belongs_to :access
  belongs_to :frecuency

  has_many :samplings

  # validates :per_cycle, numericality: { greater_than_or_equal_to: 1, less_than: 365 }
end
