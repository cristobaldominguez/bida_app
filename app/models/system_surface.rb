# == Schema Information
#
# Table name: system_surfaces
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class SystemSurface < ApplicationRecord
  has_many :inspections
end
