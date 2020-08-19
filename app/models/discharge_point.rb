# == Schema Information
#
# Table name: discharge_points
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class DischargePoint < ApplicationRecord
  has_many :plants
end
