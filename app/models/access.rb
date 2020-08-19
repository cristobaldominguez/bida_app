# == Schema Information
#
# Table name: accesses
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Access < ApplicationRecord
  has_many :sampling_lists, inverse_of: :access
end
