# == Schema Information
#
# Table name: flows
#
#  id             :bigint           not null, primary key
#  active         :boolean          default(TRUE)
#  date           :date
#  value          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  flow_report_id :bigint
#  plant_id       :bigint
#
# Indexes
#
#  index_flows_on_flow_report_id  (flow_report_id)
#  index_flows_on_plant_id        (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (flow_report_id => flow_reports.id)
#  fk_rails_...  (plant_id => plants.id)

class Flow < ApplicationRecord
  belongs_to :plant
  belongs_to :flow_report, optional: true
end
