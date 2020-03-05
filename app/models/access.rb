class Access < ApplicationRecord
  has_many :sampling_lists, inverse_of: :access
end
