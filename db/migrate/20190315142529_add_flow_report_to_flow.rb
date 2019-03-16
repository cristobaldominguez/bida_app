class AddFlowReportToFlow < ActiveRecord::Migration[5.2]
  def change
    add_reference :flows, :flow_report, foreign_key: true
  end
end
