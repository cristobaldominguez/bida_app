class Logbook < ApplicationRecord
  belongs_to :plant
  belongs_to :task_list

  has_many :logs
  accepts_nested_attributes_for :logs
end
