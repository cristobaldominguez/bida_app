class Plant < ApplicationRecord
  belongs_to :company
  belongs_to :country
  belongs_to :discharge_point
  has_and_belongs_to_many :users

  has_many :alerts, dependent: :destroy
  has_many :supports, dependent: :destroy

  belongs_to :contact, class_name: 'User'
  belongs_to :bf_contact, class_name: 'User'

  # validates :company, presence: true
end
