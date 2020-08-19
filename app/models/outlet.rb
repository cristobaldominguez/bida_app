# == Schema Information
#
# Table name: outlets
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Outlet < ApplicationRecord
  has_many :bounds, inverse_of: :outlet
end
