# == Schema Information
#
# Table name: logbooks
#
#  id           :bigint           not null, primary key
#  active       :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  plant_id     :bigint
#  task_list_id :bigint
#
# Indexes
#
#  index_logbooks_on_plant_id      (plant_id)
#  index_logbooks_on_task_list_id  (task_list_id)
#
# Foreign Keys
#
#  fk_rails_...  (plant_id => plants.id)
#  fk_rails_...  (task_list_id => task_lists.id)

class Logbook < ApplicationRecord
  after_commit :generate_logs, on: :create

  belongs_to :plant
  belongs_to :task_list

  has_many :logs
  accepts_nested_attributes_for :logs

  def generate_logs
    GenerateLogsJob.perform_later(self)
  end
end
