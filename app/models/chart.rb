class Chart < ApplicationRecord

  enum shape: %i[line pie column bar area scatter geo timeline datatable]
end
