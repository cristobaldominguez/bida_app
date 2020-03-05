class Outlet < ApplicationRecord
  has_many :bounds, inverse_of: :outlet
end
