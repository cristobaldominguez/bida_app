class FlowReport < ApplicationRecord
  belongs_to :plant
  has_many :flows

  accepts_nested_attributes_for :flows
end
