class Company < ApplicationRecord
  has_many :plants, dependent: :destroy
  belongs_to :industry

  belongs_to :contact, class_name: 'User'
  belongs_to :bf_contact, class_name: 'User'

  validates :name, presence: true, uniqueness: true
end
