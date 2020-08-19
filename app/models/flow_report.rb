# == Schema Information
#
# Table name: flow_reports
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plant_id   :bigint
#
# Indexes
#
#  index_flow_reports_on_plant_id  (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (plant_id => plants.id)

class FlowReport < ApplicationRecord
  belongs_to :plant
  has_many :flows

  accepts_nested_attributes_for :flows
end
