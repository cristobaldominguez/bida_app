class AddMetricIdToCountry < ActiveRecord::Migration[5.2]
  def change
    add_reference :countries, :metric, foreign_key: true
  end
end
