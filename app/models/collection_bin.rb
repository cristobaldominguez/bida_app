# == Schema Information
#
# Table name: collection_bins
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class CollectionBin < ApplicationRecord
  has_many :inspections
end
