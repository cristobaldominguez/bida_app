# == Schema Information
#
# Table name: supports
#
#  id               :bigint           not null, primary key
#  active           :boolean          default(TRUE), not null
#  client_onsite    :boolean
#  end_date         :date
#  start_date       :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bf_technician_id :bigint
#  client_id        :bigint
#  plant_id         :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_supports_on_bf_technician_id  (bf_technician_id)
#  index_supports_on_client_id         (client_id)
#  index_supports_on_plant_id          (plant_id)
#  index_supports_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (plant_id => plants.id)
#  fk_rails_...  (user_id => users.id)

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
