class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :plant
  belongs_to :incident_type
  belongs_to :status
  belongs_to :priority
  belongs_to :user

  has_and_belongs_to_many :users

  def send_notifications!
    users = user_ids.map { |i| User.find(i) }
    users.each do |user|
      NotificationMailer.alert_notification(user, self).deliver_later
    end
  end

  def title
    "##{id} #{incident_type.name}"
  end

  def subject
    "##{id}: #{incident_type.name}"
  end
end
