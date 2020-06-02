class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  serialize :system_size, Array

  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }
  scope :sort_by_id, -> { order('id ASC') }
  scope :created_between, ->(start_date, end_date) { where('date BETWEEN ? AND ?', start_date, end_date) }

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def inactive!
    self.active = false
    self.save
  end

  def active!
    self.active = true
    self.save
  end
end
