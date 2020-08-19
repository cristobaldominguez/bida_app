# == Schema Information
#
# Table name: flies
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Fly < ApplicationRecord
  has_many :inspections
end
