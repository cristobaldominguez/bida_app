class Sampling < ApplicationRecord
  belongs_to :standard
  belongs_to :sampling_list

  scope :created_before, ->(end_date) { where('sampling_lists.created_at < ?', end_date) }
end
