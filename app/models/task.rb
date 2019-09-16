class Task < ApplicationRecord
  has_many :log_standards

  enum season: %i[no show hide]
  enum frecuency: %w[daily weekly every_2_weeks monthly every_x_months]
  enum input_type: ['checkbox', 'inches', 'pH record', 'date', 'PSI', 'boolean', '% of bed', 'Low/Medium/High Density', 'COD Record', 'Low/Medium/Strong Odor', 'file']
end
