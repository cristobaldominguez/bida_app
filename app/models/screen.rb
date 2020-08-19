# == Schema Information
#
# Table name: screens
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Screen < ApplicationRecord
  has_many :inspections
end
