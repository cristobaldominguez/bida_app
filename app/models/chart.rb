# == Schema Information
#
# Table name: charts
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  name       :string
#  shape      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Chart < ApplicationRecord
  has_many :graph_standards

  enum shape: %i[line pie column bar area scatter geo timeline datatable]
end
