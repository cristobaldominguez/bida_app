# == Schema Information
#
# Table name: samplings
#
#  id               :bigint           not null, primary key
#  active           :boolean          default(TRUE)
#  date             :date
#  value_in         :integer
#  value_out        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  sampling_list_id :bigint
#  standard_id      :bigint
#
# Indexes
#
#  index_samplings_on_sampling_list_id  (sampling_list_id)
#  index_samplings_on_standard_id       (standard_id)
#
# Foreign Keys
#
#  fk_rails_...  (sampling_list_id => sampling_lists.id)
#  fk_rails_...  (standard_id => standards.id)

class Sampling < ApplicationRecord
  belongs_to :standard
  belongs_to :sampling_list

  scope :created_before, ->(end_date) { where('sampling_lists.created_at < ?', end_date) }

  accepts_nested_attributes_for :standard
end
