class WorkSummary < ApplicationRecord
  belongs_to :support

  validates :hours, numericality: { greater_than: 0 }
end
