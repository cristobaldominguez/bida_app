# == Schema Information
#
# Table name: incident_types
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  i18n_name  :jsonb
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class IncidentType < ApplicationRecord
  has_many :alerts

  serialize :i18n_name

  def self.i18n_name(current_locale)
    active.sort.pluck(:id, :i18n_name).map {|n| [n.first, n.second[current_locale]] }
  end
end
