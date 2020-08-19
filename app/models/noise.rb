# == Schema Information
#
# Table name: noises
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Noise < ApplicationRecord
  has_many :inspections
end
