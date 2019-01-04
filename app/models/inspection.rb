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
end
