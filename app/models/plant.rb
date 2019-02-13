class Plant < ApplicationRecord
  belongs_to :company
  belongs_to :country
  belongs_to :discharge_point
  has_and_belongs_to_many :users

  has_many :alerts, dependent: :destroy
  has_many :supports, dependent: :destroy
  has_many :inspections, dependent: :destroy

  has_many :log_standards
  has_many :logbooks

  belongs_to :contact, class_name: 'User'
  belongs_to :bf_contact, class_name: 'User'

  has_many :standards, dependent: :destroy
  has_many :sampling_lists, dependent: :destroy

  accepts_nested_attributes_for :standards, allow_destroy: true
  accepts_nested_attributes_for :sampling_lists, allow_destroy: true
  accepts_nested_attributes_for :log_standards, allow_destroy: true

  def metrics
    country.metric
  end
end
