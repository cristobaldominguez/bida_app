# == Schema Information
#
# Table name: pipings
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Piping < ApplicationRecord
  has_many :inspections
end
