# == Schema Information
#
# Table name: plants
#
#  id                             :bigint           not null, primary key
#  active                         :boolean          default(TRUE)
#  address01                      :string
#  address02                      :string
#  code                           :string
#  flow_design                    :integer
#  high_season                    :boolean          default(FALSE)
#  name                           :string
#  phone                          :string
#  report_preface                 :string
#  startup_date                   :date
#  state                          :string
#  system_purpose                 :string
#  system_size                    :string
#  unit_number                    :string
#  zip                            :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  bf_contact_id                  :bigint
#  company_id                     :bigint           not null
#  contact_id                     :bigint
#  country_id                     :bigint
#  discharge_point_id             :bigint
#  logbook_bf_responsible_id      :bigint
#  logbook_bf_supervisor_id       :bigint
#  logbook_company_responsible_id :bigint
#
# Indexes
#
#  index_plants_on_bf_contact_id                   (bf_contact_id)
#  index_plants_on_company_id                      (company_id)
#  index_plants_on_contact_id                      (contact_id)
#  index_plants_on_country_id                      (country_id)
#  index_plants_on_discharge_point_id              (discharge_point_id)
#  index_plants_on_logbook_bf_responsible_id       (logbook_bf_responsible_id)
#  index_plants_on_logbook_bf_supervisor_id        (logbook_bf_supervisor_id)
#  index_plants_on_logbook_company_responsible_id  (logbook_company_responsible_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (discharge_point_id => discharge_points.id)

class Plant < ApplicationRecord
  after_create_commit :generate_logbook
  before_save :filter_unit_number

  # validations
  validates :code, presence: true, uniqueness: true
  validates :flow_design, numericality: { greater_than: 0 }

  belongs_to :company
  belongs_to :country
  belongs_to :discharge_point
  has_and_belongs_to_many :users

  has_many :alerts, dependent: :destroy
  has_many :supports, dependent: :destroy
  has_many :inspections, dependent: :destroy
  has_many :todos

  has_many :task_lists
  has_many :logbooks

  has_many :flows, dependent: :destroy
  has_many :flow_reports, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :graph_standards, dependent: :destroy

  belongs_to :logbook_bf_responsible, class_name: 'User'
  belongs_to :logbook_bf_supervisor, class_name: 'User'
  belongs_to :logbook_company_responsible, class_name: 'User'

  belongs_to :contact, class_name: 'User'
  belongs_to :bf_contact, class_name: 'User'

  has_many :standards, dependent: :destroy
  has_many :sampling_lists, dependent: :destroy

  has_one_attached :cover
  has_one_attached :discharge_permit

  accepts_nested_attributes_for :standards, allow_destroy: true
  accepts_nested_attributes_for :sampling_lists, allow_destroy: true
  accepts_nested_attributes_for :task_lists, allow_destroy: false
  accepts_nested_attributes_for :logbooks, allow_destroy: false
  accepts_nested_attributes_for :graph_standards, allow_destroy: true

  serialize :unit_number, Array

  enum frecuency: %w[daily weekly every_2_weeks monthly every_x_months]

  scope :filter_by_id, ->(id) { where.not(id: id) }

  def generate_logbook
    logbooks.create(task_list: task_lists.last)
  end

  def filter_unit_number
    self.unit_number = unit_number.reject(&:empty?)
  end

  def metrics
    country.metric
  end

  def cover_hero
    cover.variant(resize: '2280')
  end
end
