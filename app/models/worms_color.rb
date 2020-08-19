# == Schema Information
#
# Table name: worms_colors
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class WormsColor < ApplicationRecord
  has_many :inspections
end
