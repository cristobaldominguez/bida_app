class Logbook < ApplicationRecord
  belongs_to :plant

  has_many :logs
  accepts_nested_attributes_for :logs
end
