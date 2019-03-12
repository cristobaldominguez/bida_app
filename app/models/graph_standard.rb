class GraphStandard < ApplicationRecord
  belongs_to :plant
  belongs_to :chart

  has_many :graphs

  accepts_nested_attributes_for :chart, allow_destroy: true
end
