class LogStandard < ApplicationRecord
  belongs_to :task
  belongs_to :frecuency
  belongs_to :plant

  has_many :logs

  accepts_nested_attributes_for :task
end
