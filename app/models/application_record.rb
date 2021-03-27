class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  serialize :system_size, Array

  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }
  scope :sort_by_id, -> { order('id ASC') }
  scope :without_value, -> { where(value: [nil, '']) }
  scope :created_between, ->(start_date, end_date) { where('date BETWEEN ? AND ?', start_date, end_date) }
  scope :created_before, ->(date) { where('created_at <= ?', date) }

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def self.all_options
    options = self.all.sort.pluck(:id, :option)
    params_translations(options)
  end

  def self.all_names
    names = self.all.sort.pluck(:id, :name)
    params_translations(names)
  end

  def self.all_i18n_names(locale)
    names = self.active.sort.pluck(:id, :i18n_name).map {|n| [n.first, n.second[locale]] }
    params_translations(names)
  end

  def self.params_translations(options)
    options.map { |opt| [opt.first, model_name.name.classify.constantize.human_enum_name(model_name.plural.to_sym, opt.second.parameterize(separator: '_'))] }
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
