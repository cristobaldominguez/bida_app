class Flow < ApplicationRecord
  belongs_to :plant
  belongs_to :flow_report, optional: true
end
