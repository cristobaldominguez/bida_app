class Metric < ApplicationRecord
  belongs_to :metric_type
  has_many :countries
end
