# == Schema Information
#
# Table name: inspections
#
#  id                         :bigint           not null, primary key
#  active                     :boolean          default(TRUE)
#  bida_comments              :text
#  birds                      :boolean
#  date                       :date
#  on_site_client             :boolean
#  plant_odor_description     :text
#  pumps_comments             :text
#  pumps_noise_description    :text
#  pumps_psi                  :float
#  screen_comments            :text
#  summary_comments           :text
#  worms_activity_description :text
#  worms_color_description    :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  bed_compaction_id          :bigint
#  collection_bin_id          :bigint
#  fly_id                     :bigint
#  noise_id                   :bigint
#  odor_id                    :bigint
#  on_site_user_id            :bigint
#  piping_id                  :bigint
#  plant_id                   :bigint
#  ponding_id                 :bigint
#  report_technician_id       :bigint
#  screen_id                  :bigint
#  sprinklers_head_id         :bigint
#  sprinklers_pressure_id     :bigint
#  system_surface_id          :bigint
#  user_id                    :bigint
#  worms_activity_id          :bigint
#  worms_color_id             :bigint
#  worms_density_id           :bigint
#
# Indexes
#
#  index_inspections_on_bed_compaction_id       (bed_compaction_id)
#  index_inspections_on_collection_bin_id       (collection_bin_id)
#  index_inspections_on_fly_id                  (fly_id)
#  index_inspections_on_noise_id                (noise_id)
#  index_inspections_on_odor_id                 (odor_id)
#  index_inspections_on_on_site_user_id         (on_site_user_id)
#  index_inspections_on_piping_id               (piping_id)
#  index_inspections_on_plant_id                (plant_id)
#  index_inspections_on_ponding_id              (ponding_id)
#  index_inspections_on_report_technician_id    (report_technician_id)
#  index_inspections_on_screen_id               (screen_id)
#  index_inspections_on_sprinklers_head_id      (sprinklers_head_id)
#  index_inspections_on_sprinklers_pressure_id  (sprinklers_pressure_id)
#  index_inspections_on_system_surface_id       (system_surface_id)
#  index_inspections_on_user_id                 (user_id)
#  index_inspections_on_worms_activity_id       (worms_activity_id)
#  index_inspections_on_worms_color_id          (worms_color_id)
#  index_inspections_on_worms_density_id        (worms_density_id)
#
# Foreign Keys
#
#  fk_rails_...  (bed_compaction_id => bed_compactions.id)
#  fk_rails_...  (collection_bin_id => collection_bins.id)
#  fk_rails_...  (fly_id => flies.id)
#  fk_rails_...  (noise_id => noises.id)
#  fk_rails_...  (odor_id => odors.id)
#  fk_rails_...  (piping_id => pipings.id)
#  fk_rails_...  (plant_id => plants.id)
#  fk_rails_...  (ponding_id => pondings.id)
#  fk_rails_...  (screen_id => screens.id)
#  fk_rails_...  (sprinklers_head_id => sprinklers_heads.id)
#  fk_rails_...  (sprinklers_pressure_id => sprinklers_pressures.id)
#  fk_rails_...  (system_surface_id => system_surfaces.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (worms_activity_id => worms_activities.id)
#  fk_rails_...  (worms_color_id => worms_colors.id)
#  fk_rails_...  (worms_density_id => worms_densities.id)

class Inspection < ApplicationRecord
  belongs_to :user
  belongs_to :plant
  belongs_to :screen
  belongs_to :collection_bin
  belongs_to :noise
  belongs_to :sprinklers_pressure
  belongs_to :sprinklers_head
  belongs_to :piping
  belongs_to :system_surface
  belongs_to :bed_compaction
  belongs_to :ponding
  belongs_to :odor
  belongs_to :fly

  has_many :fluents

  has_and_belongs_to_many :users
  belongs_to :on_site_user, class_name: 'User'
  belongs_to :report_technician, class_name: 'User'

  accepts_nested_attributes_for :fluents, allow_destroy: true

  def send_notifications!
    users = user_ids.map { |i| User.find(i) }
    users.each do |user|
      NotificationMailer.inspection_notification(user, self).deliver_later
    end
  end

  def title
    "##{id} #{date}"
  end
end
