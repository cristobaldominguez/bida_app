# == Schema Information
#
# Table name: worms_activities
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class WormsActivity < ApplicationRecord
  has_many :inspections
end
