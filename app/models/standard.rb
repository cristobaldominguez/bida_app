class Standard < ApplicationRecord
  belongs_to :option
  belongs_to :plant, optional: true
  has_many :bounds, dependent: :destroy
  has_many :samplings, dependent: :destroy

  accepts_nested_attributes_for :bounds, allow_destroy: true
  accepts_nested_attributes_for :option
  accepts_nested_attributes_for :samplings

  def option_attributes=(attributes)
    self.option = Option.find(attributes[:id])
    super(attributes)
  end

  def option_name
    option.name.to_s
  end
end
