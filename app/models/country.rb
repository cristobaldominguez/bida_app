class Country < ApplicationRecord
  has_many :plants
  belongs_to :metric

  validates :name, presence: true
end
