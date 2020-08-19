# == Schema Information
#
# Table name: sampling_lists
#
#  id           :bigint           not null, primary key
#  active       :boolean          default(TRUE)
#  date         :date
#  per_cycle    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  access_id    :bigint
#  frecuency_id :bigint
#  plant_id     :bigint
#
# Indexes
#
#  index_sampling_lists_on_access_id     (access_id)
#  index_sampling_lists_on_frecuency_id  (frecuency_id)
#  index_sampling_lists_on_plant_id      (plant_id)
#
# Foreign Keys
#
#  fk_rails_...  (access_id => accesses.id)
#  fk_rails_...  (frecuency_id => frecuencies.id)
#  fk_rails_...  (plant_id => plants.id)

class SamplingList < ApplicationRecord
  belongs_to :plant, optional: true
  belongs_to :access
  belongs_to :frecuency

  has_many :samplings

  scope :external, -> { where(access_id: Access.find_by(name: 'External').id) }
  scope :internal, -> { where(access_id: Access.find_by(name: 'Internal').id) }

  scope :created_between, ->(start_date, end_date) { where('sampling_lists.created_at BETWEEN ? and ?', start_date, end_date) }
  scope :created_before, ->(end_date) { where('sampling_lists.date < ?', end_date) }

  accepts_nested_attributes_for :samplings, allow_destroy: true
  accepts_nested_attributes_for :access

  # validates :per_cycle, numericality: { greater_than_or_equal_to: 1, less_than: 365 }

  def access_attributes=(attributes)
    self.access = Access.find(attributes[:id])
    super(attributes)
  end

  def external?
    access.name == 'External'
  end

  def internal?
    access.name == 'Internal'
  end
end
