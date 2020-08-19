# == Schema Information
#
# Table name: odors
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Odor < ApplicationRecord
  has_many :inspections
  has_many :fluents
end
