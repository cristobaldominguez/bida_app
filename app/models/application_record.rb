class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  serialize :system_size, Array

  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }

end
