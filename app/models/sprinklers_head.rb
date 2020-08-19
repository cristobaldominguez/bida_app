# == Schema Information
#
# Table name: sprinklers_heads
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class SprinklersHead < ApplicationRecord
  has_many :inspections
end
