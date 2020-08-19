# == Schema Information
#
# Table name: pondings
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Ponding < ApplicationRecord
  has_many :inspections
end
