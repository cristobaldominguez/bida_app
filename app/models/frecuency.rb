# == Schema Information
#
# Table name: frecuencies
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Frecuency < ApplicationRecord
  has_many :sampling_lists, inverse_of: :frecuency
  has_many :tasks, inverse_of: :frecuency
end
