class Frecuency < ApplicationRecord
  has_many :sampling_lists
  has_many :tasks
end
