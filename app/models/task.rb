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
  enum input_type: ['checkbox', 'number', 'date', 'yes/no', 'Low/Medium/High Density', 'Low/Medium/Strong Odor']
  enum data_type: %w[other pH PSI gallons liters COD % mg/L inches trucks loads yards hours celcius fahrenheit moisture GPM]
end
