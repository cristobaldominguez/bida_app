class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :task_list, foreign_key: true
      t.boolean :active, default: true
      t.integer :season, default: 0
      t.integer :frecuency, default: 0
      t.integer :input_type, default: 0
      t.integer :data_type, default: 0
      t.integer :responsible, default: 0
      t.string :cycle
      t.string :name, null: false
      t.string :comment

      t.timestamps
    end
  end
end
