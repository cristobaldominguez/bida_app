# == Schema Information
#
# Table name: options
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Option < ApplicationRecord
  has_many :standards, inverse_of: :option
end
