# == Schema Information
#
# Table name: countries
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  metric_id  :bigint
#
# Indexes
#
#  index_countries_on_metric_id  (metric_id)
#
# Foreign Keys
#
#  fk_rails_...  (metric_id => metrics.id)

class Country < ApplicationRecord
  has_many :plants
  belongs_to :metric

  validates :name, presence: true
end
