class CreateTaskLists < ActiveRecord::Migration[5.2]
  def change
    create_table :task_lists do |t|
      t.references :plant, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
