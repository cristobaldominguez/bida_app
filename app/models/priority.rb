# == Schema Information
#
# Table name: priorities
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Priority < ApplicationRecord
  has_many :alerts
end
