class CreateLogStandards < ActiveRecord::Migration[5.2]
  def change
    create_table :log_standards do |t|
      t.references :task, foreign_key: true
      t.references :plant, foreign_key: true
      t.references :frecuency, foreign_key: true
      t.boolean :active, default: true
      t.integer :responsible, default: 0
      t.integer :cycle, null: false

      t.timestamps
    end
  end
end
