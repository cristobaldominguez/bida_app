class CreateMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :metrics do |t|
      t.references :metric_type, foreign_key: true
      t.string :length
      t.string :volume
      t.string :area
      t.string :mass

      t.timestamps
    end
  end
end
