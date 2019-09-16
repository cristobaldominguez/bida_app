class CurrentLogStandard < ApplicationRecord
  belongs_to :log_standard
  belongs_to :plant
  has_many :logs

  accepts_nested_attributes_for :log_standard

  enum frecuency: %w[daily weekly every_2_weeks monthly every_x_months]
end
