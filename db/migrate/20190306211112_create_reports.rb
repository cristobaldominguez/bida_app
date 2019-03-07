class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.references :plant, foreign_key: true
      t.integer :state, default: 0
      t.string :system_purpose
      t.string :report_preface
      t.string :flow_design
      t.string :system_size
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
