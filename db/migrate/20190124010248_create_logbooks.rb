class CreateLogbooks < ActiveRecord::Migration[5.2]
  def change
    create_table :logbooks do |t|
      t.references :task_list, foreign_key: true
      t.references :plant, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
