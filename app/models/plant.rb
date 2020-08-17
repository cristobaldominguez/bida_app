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
