class Plant < ApplicationRecord
  belongs_to :company
  belongs_to :country
  belongs_to :discharge_point
  has_and_belongs_to_many :users

  # validates :company, presence: true
end
