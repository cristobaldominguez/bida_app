class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :log_type, foreign_key: true
      t.references :input_type, foreign_key: true
      t.references :frecuency, foreign_key: true
      t.integer :cycle, default: 1, null: false
      t.integer :responsible, default: 0
      t.boolean :active, default: true
      t.string :name, null: false
      t.string :comment

      t.timestamps
    end
  end
end
