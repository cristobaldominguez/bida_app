# == Schema Information
#
# Table name: metrics
#
#  id             :bigint           not null, primary key
#  area           :string
#  length         :string
#  mass           :string
#  temperature    :string
#  volume         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  metric_type_id :bigint
#
# Indexes
#
#  index_metrics_on_metric_type_id  (metric_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (metric_type_id => metric_types.id)

class Metric < ApplicationRecord
  belongs_to :metric_type
  has_many :countries
end
