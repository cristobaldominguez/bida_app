# == Schema Information
#
# Table name: sprinklers_pressures
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class SprinklersPressure < ApplicationRecord
  has_many :inspections
end
