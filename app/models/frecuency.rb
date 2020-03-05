class Frecuency < ApplicationRecord
  has_many :sampling_lists, inverse_of: :frecuency
  has_many :tasks, inverse_of: :frecuency
end
