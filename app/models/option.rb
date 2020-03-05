class Option < ApplicationRecord
  has_many :standards, inverse_of: :option
end
