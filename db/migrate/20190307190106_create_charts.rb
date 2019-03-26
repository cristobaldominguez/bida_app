class CreateCharts < ActiveRecord::Migration[5.2]
  def change
    create_table :charts do |t|
      t.string :name
      t.integer :shape
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
