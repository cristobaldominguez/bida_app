# == Schema Information
#
# Table name: outputs
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Output < ApplicationRecord
  has_many :fluents
end
