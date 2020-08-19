# == Schema Information
#
# Table name: standards
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  enabled    :boolean          default(TRUE)
#  isRange    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  option_id  :bigint
#  plant_id   :bigint
#
# Indexes
#
#  index_standards_on_option_id  (option_id)
#  index_standards_on_plant_id   (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (option_id => options.id)
#  fk_rails_...  (plant_id => plants.id)

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
