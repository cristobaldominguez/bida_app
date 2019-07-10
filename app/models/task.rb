class Task < ApplicationRecord
  belongs_to :log_type
  belongs_to :input_type
  belongs_to :frecuency

  has_many :log_standards

  enum season: %i[no show hide]
  enum frecuency: %w[daily weekly every_2_weeks monthly every_x_months]
end
