class Plant < ApplicationRecord
  belongs_to :company
  belongs_to :country
  belongs_to :discharge_point

  # validates :company, presence: true
end
