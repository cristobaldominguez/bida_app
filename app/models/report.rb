class Report < ApplicationRecord
  belongs_to :plant

  has_many :graphs

  enum state: %i[draft published]

  accepts_nested_attributes_for :graphs, allow_destroy: true
end
