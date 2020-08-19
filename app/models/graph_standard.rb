# == Schema Information
#
# Table name: graph_standards
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  show       :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chart_id   :bigint
#  plant_id   :bigint
#
# Indexes
#
#  index_graph_standards_on_chart_id  (chart_id)
#  index_graph_standards_on_plant_id  (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (chart_id => charts.id)
#  fk_rails_...  (plant_id => plants.id)

class GraphStandard < ApplicationRecord
  belongs_to :plant
  belongs_to :chart

  has_many :graphs

  accepts_nested_attributes_for :chart, allow_destroy: true
end
