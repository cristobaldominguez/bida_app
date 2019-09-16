class CreateLogStandards < ActiveRecord::Migration[5.2]
  def change
    create_table :log_standards do |t|
      t.references :task, foreign_key: true
      t.references :plant, foreign_key: true
      t.boolean :active, default: true
      t.integer :responsible, default: 0
      t.integer :season, null: false
      t.string :name, null: false
      t.string :comment

      t.timestamps
    end
  end
end
