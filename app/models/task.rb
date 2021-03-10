# == Schema Information
#
# Table name: tasks
#
#  id           :bigint           not null, primary key
#  active       :boolean          default(TRUE)
#  cycle        :string
#  data_type    :integer          default("other")
#  frecuency    :integer          default("daily")
#  i18n_comment :jsonb
#  i18n_name    :jsonb
#  input_type   :integer          default("checkbox")
#  responsible  :integer          default(0)
#  season       :integer          default("no")
#  sort         :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  task_list_id :bigint
#
# Indexes
#
#  index_tasks_on_i18n_comment  (i18n_comment) USING gin
#  index_tasks_on_i18n_name     (i18n_name) USING gin
#  index_tasks_on_task_list_id  (task_list_id)
#
# Foreign Keys
#
#  fk_rails_...  (task_list_id => task_lists.id)

class Task < ApplicationRecord
  belongs_to :task_list
  has_many :logs

  accepts_nested_attributes_for :task_list

  I18n.available_locales.each { |locale| store_accessor locale.to_sym }
  serialize :i18n_name
  serialize :i18n_comment

  scope :find_by_name, ->(lang, text) { where('i18n_name @> ?', { lang.to_sym => text }.to_json) }
  scope :find_by_comment, ->(lang, text) { where('i18n_comment @> ?', { lang.to_sym => text }.to_json) }

  enum season: %i[no in_season out_season]
  enum frecuency: %w[daily weekly every_2_weeks monthly every_x_months]
  enum input_type: ['checkbox', 'number', 'date', 'yes/no', 'Low/Medium/High Density', 'Low/Medium/Strong Odor', 'full/not_full']
  enum data_type: %w[other pH PSI gallons liters COD % mg/L inches trucks loads yards hours celcius fahrenheit moisture GPM cleanings 0-9 PPM]
end
