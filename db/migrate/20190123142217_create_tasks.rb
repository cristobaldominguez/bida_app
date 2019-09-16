class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :input_type, default: 0
      t.integer :frecuency, default: 0
      t.integer :season, default: 0
      t.integer :responsible, default: 0
      t.boolean :active, default: true
      t.string :name, null: false
      t.string :comment
      t.string :cycle

      t.timestamps
    end
  end
end
