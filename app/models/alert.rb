# == Schema Information
#
# Table name: alerts
#
#  id                        :bigint           not null, primary key
#  active                    :boolean          default(TRUE), not null
#  incident_description      :text
#  incident_resolution       :text
#  negative_impact           :text
#  solution                  :text
#  solution_target_date      :date
#  technician_hours_required :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  incident_type_id          :bigint
#  plant_id                  :bigint
#  priority_id               :bigint
#  status_id                 :bigint
#  user_id                   :bigint
#
# Indexes
#
#  index_alerts_on_incident_type_id  (incident_type_id)
#  index_alerts_on_plant_id          (plant_id)
#  index_alerts_on_priority_id       (priority_id)
#  index_alerts_on_status_id         (status_id)
#  index_alerts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (incident_type_id => incident_types.id)
#  fk_rails_...  (plant_id => plants.id)
#  fk_rails_...  (priority_id => priorities.id)
#  fk_rails_...  (status_id => statuses.id)
#  fk_rails_...  (user_id => users.id)

class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :plant
  belongs_to :incident_type
  belongs_to :status
  belongs_to :priority
  belongs_to :user

  has_and_belongs_to_many :users

  has_many_attached :images

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
