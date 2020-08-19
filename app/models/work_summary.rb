# == Schema Information
#
# Table name: work_summaries
#
#  id          :bigint           not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  hours       :integer
#  materials   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  support_id  :bigint
#
# Indexes
#
#  index_work_summaries_on_support_id  (support_id)
#
# Foreign Keys
#
#  fk_rails_...  (support_id => supports.id)

class WorkSummary < ApplicationRecord
  belongs_to :support

  validates :hours, numericality: { greater_than: 0 }
end
