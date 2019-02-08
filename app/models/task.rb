class Task < ApplicationRecord
  belongs_to :log_type
  belongs_to :input_type
  belongs_to :frecuency

  has_many :log_standards
end
