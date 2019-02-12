class CreateMetricTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :metric_types do |t|
      t.string :option

      t.timestamps
    end
  end
end
