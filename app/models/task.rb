class Task < ApplicationRecord
  has_many :log_standards

  enum season: %i[no show hide]
  enum frecuency: %w[daily weekly every_2_weeks monthly every_x_months]
  enum input_type: ['checkbox', 'number', 'date', 'yes/no', 'Low/Medium/High Density', 'Low/Medium/Strong Odor']
  enum data_type: %w[other pH PSI gallons liters COD % inches]
end
