class GraphStandard < ApplicationRecord
  belongs_to :plant
  belongs_to :chart

  accepts_nested_attributes_for :chart, allow_destroy: true
end
