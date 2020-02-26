class Bound < ApplicationRecord
  belongs_to :standard, optional: true
  belongs_to :outlet, optional: true

  accepts_nested_attributes_for :outlet
end
