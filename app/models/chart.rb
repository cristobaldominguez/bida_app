class Chart < ApplicationRecord
  has_many :graph_standards

  enum shape: %i[line pie column bar area scatter geo timeline datatable]
end
