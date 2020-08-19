# == Schema Information
#
# Table name: reports
#
#  id             :bigint           not null, primary key
#  active         :boolean          default(TRUE)
#  date           :date
#  flow_design    :string
#  report_preface :string
#  state          :integer          default("draft")
#  system_purpose :string
#  system_size    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  plant_id       :bigint
#
# Indexes
#
#  index_reports_on_plant_id  (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (plant_id => plants.id)

class Report < ApplicationRecord
  belongs_to :plant

  has_many :graphs

  enum state: %i[draft published]

  accepts_nested_attributes_for :graphs, allow_destroy: true
end
