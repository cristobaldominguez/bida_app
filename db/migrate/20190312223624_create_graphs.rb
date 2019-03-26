class CreateGraphs < ActiveRecord::Migration[5.2]
  def change
    create_table :graphs do |t|
      t.references :report, foreign_key: true
      t.references :graph_standard, foreign_key: true
      t.boolean :active, default: true
      t.text :comment

      t.timestamps
    end
  end
end
