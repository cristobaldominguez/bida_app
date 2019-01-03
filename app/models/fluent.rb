class Fluent < ApplicationRecord
  belongs_to :inspection
  belongs_to :output
  belongs_to :color
  belongs_to :odor
end
