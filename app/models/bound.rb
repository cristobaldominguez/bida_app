class Bound < ApplicationRecord
  belongs_to :standard, optional: true
  belongs_to :outlet
end
