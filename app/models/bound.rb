class Bound < ApplicationRecord
  belongs_to :standard, inverse_of: :bounds, optional: true
  belongs_to :outlet, inverse_of: :bounds, optional: true

  accepts_nested_attributes_for :outlet

  def outlet_attributes=(attributes)
    self.outlet = Outlet.find(attributes['id'])
    super(attributes)
  end
end
