class Odor < ApplicationRecord
  has_many :inspections
  has_many :fluents
end
