class Plant < ApplicationRecord
  after_create_commit :generate_logbook

  # validations
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  belongs_to :company
  belongs_to :country
  belongs_to :discharge_point
  has_and_belongs_to_many :users

  has_many :alerts, dependent: :destroy
  has_many :supports, dependent: :destroy
  has_many :inspections, dependent: :destroy

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

  enum frecuency: %w[daily weekly every_2_weeks monthly every_x_months]

  def generate_logbook
    logbook = logbooks.create(task_list: task_lists.last)
    GenerateLogsJob.perform_later(logbook)
  end

  def metrics
    country.metric
  end

  def cover_hero
    cover.variant(resize: '2280')
  end
end
