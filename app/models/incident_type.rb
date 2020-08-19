# == Schema Information
#
# Table name: incident_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

class IncidentType < ApplicationRecord
  has_many :alerts
end
