# == Schema Information
#
# Table name: metric_types
#
#  id         :bigint           not null, primary key
#  option     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class MetricType < ApplicationRecord
  has_many :metrics
end
