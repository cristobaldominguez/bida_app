# == Schema Information
#
# Table name: colors
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Color < ApplicationRecord
  has_many :inspections
  has_many :fluents
end
