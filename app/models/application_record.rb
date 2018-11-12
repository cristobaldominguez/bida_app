class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }

end
