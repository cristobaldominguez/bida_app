class Company < ApplicationRecord
  has_many :plants, dependent: :destroy
  belongs_to :industry
end
