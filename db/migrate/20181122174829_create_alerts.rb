class CreateAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :alerts do |t|
      t.references :user, foreign_key: true
      t.references :plant, foreign_key: true
      t.references :incident_type, foreign_key: true
      t.references :status, foreign_key: true
      t.references :priority, foreign_key: true
      t.boolean :active, null: false, default: true
      t.text :incident_description
      t.text :negative_impact
      t.text :solution
      t.text :incident_resolution
      t.date :solution_target_date
      t.integer :technician_hours_required

      t.timestamps
    end
  end
end
