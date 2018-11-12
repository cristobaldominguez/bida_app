class Plant < ApplicationRecord
  belongs_to :company
  belongs_to :country

  # validates :company, presence: true
end
