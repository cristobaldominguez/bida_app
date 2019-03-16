class CreateFlowReports < ActiveRecord::Migration[5.2]
  def change
    create_table :flow_reports do |t|
      t.references :plant, foreign_key: true
      t.date :date
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
