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
