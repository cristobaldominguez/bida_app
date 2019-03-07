class AddReportPrefaceToPlant < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :report_preface, :string
  end
end
