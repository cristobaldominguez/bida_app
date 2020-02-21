class Standard < ApplicationRecord
  belongs_to :option
  belongs_to :plant, optional: true
  has_many :bounds, dependent: :destroy
  has_many :samplings, dependent: :destroy

  accepts_nested_attributes_for :bounds, allow_destroy: true
  accepts_nested_attributes_for :option
  accepts_nested_attributes_for :samplings
end
