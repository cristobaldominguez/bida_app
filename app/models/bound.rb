# == Schema Information
#
# Table name: bounds
#
#  id          :bigint           not null, primary key
#  active      :boolean
#  from        :float
#  to          :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  outlet_id   :bigint
#  standard_id :bigint
#
# Indexes
#
#  index_bounds_on_outlet_id    (outlet_id)
#  index_bounds_on_standard_id  (standard_id)
#
# Foreign Keys
#
#  fk_rails_...  (outlet_id => outlets.id)
#  fk_rails_...  (standard_id => standards.id)

class Bound < ApplicationRecord
  belongs_to :standard, inverse_of: :bounds, optional: true
  belongs_to :outlet, inverse_of: :bounds, optional: true

  accepts_nested_attributes_for :outlet

  def outlet_attributes=(attributes)
    self.outlet = Outlet.find(attributes['id'])
    super(attributes)
  end
end
