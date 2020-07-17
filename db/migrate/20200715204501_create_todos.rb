class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :completed, null: false, default: false
      t.integer :label, null: false, default: 0
      t.date :deadline
      t.integer :responsible_id, null: false
      t.integer :created_by_id
      t.integer :sort, default: 1
      t.boolean :active, null: false, default: true
      t.jsonb :detail, default: {}
      t.references :plant, foreign_key: true

      t.timestamps
    end
  end
end
