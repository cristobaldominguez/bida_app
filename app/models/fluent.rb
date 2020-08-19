# == Schema Information
#
# Table name: fluents
#
#  id                :bigint           not null, primary key
#  bod               :float
#  cod               :float
#  color_description :text
#  ec                :float
#  odor_description  :text
#  ph                :float
#  sample_comments   :text
#  tn                :float
#  tp                :float
#  tss               :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  color_id          :bigint
#  inspection_id     :bigint
#  odor_id           :bigint
#  output_id         :bigint
#
# Indexes
#
#  index_fluents_on_color_id       (color_id)
#  index_fluents_on_inspection_id  (inspection_id)
#  index_fluents_on_odor_id        (odor_id)
#  index_fluents_on_output_id      (output_id)
#
# Foreign Keys
#
#  fk_rails_...  (color_id => colors.id)
#  fk_rails_...  (inspection_id => inspections.id)
#  fk_rails_...  (odor_id => odors.id)
#  fk_rails_...  (output_id => outputs.id)

class Fluent < ApplicationRecord
  belongs_to :inspection
  belongs_to :output
  belongs_to :color
  belongs_to :odor
end
