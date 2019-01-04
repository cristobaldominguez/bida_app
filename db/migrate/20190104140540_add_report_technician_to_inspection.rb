class AddReportTechnicianToInspection < ActiveRecord::Migration[5.2]
  def change
    add_reference :inspections, :report_technician
  end
end
