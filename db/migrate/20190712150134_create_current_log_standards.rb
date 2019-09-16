class CreateCurrentLogStandards < ActiveRecord::Migration[5.2]
  def change
    create_table :current_log_standards do |t|
      t.references :log_standard, foreign_key: true
      t.references :plant, foreign_key: true
      t.integer :frecuency
      t.text :cycle

      t.timestamps
    end
  end
end
