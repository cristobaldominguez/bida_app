class CreateGraphStandards < ActiveRecord::Migration[5.2]
  def change
    create_table :graph_standards do |t|
      t.references :plant, foreign_key: true
      t.references :chart, foreign_key: true
      t.boolean :active, default: true
      t.boolean :show, default: true

      t.timestamps
    end
  end
end
