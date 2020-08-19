# == Schema Information
#
# Table name: bed_compactions
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class BedCompaction < ApplicationRecord
  has_many :inspections
end
