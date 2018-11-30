class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :plant
  belongs_to :incident_type
  belongs_to :status
  belongs_to :priority
  belongs_to :user

  def title
    "##{id} #{incident_type.name}"
  end
end
