class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :plant
  belongs_to :incident_type
  belongs_to :status
  belongs_to :priority
  belongs_to :user

  has_and_belongs_to_many :users

  def title
    "##{id} #{incident_type.name}"
  end
end
