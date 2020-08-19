# == Schema Information
#
# Table name: worms_densities
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class WormsDensity < ApplicationRecord
  has_many :inspections
end
