class Support < ApplicationRecord
  belongs_to :user
  belongs_to :plant

  has_many :work_summaries, dependent: :destroy

  belongs_to :client, class_name: 'User'
  belongs_to :bf_technician, class_name: 'User'

  has_and_belongs_to_many :users

  accepts_nested_attributes_for :work_summaries,
    reject_if: proc { |att| att['description'].blank? && att['hours'].blank? },
    allow_destroy: true

  def send_notifications!
    users = user_ids.map { |i| User.find(i) }
    users.each do |user|
      NotificationMailer.support_notification(user, self).deliver_later
    end
  end

  def number
    "Ticket ##{1000 + id}"
  end
end
