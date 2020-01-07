class AddDateToInspections < ActiveRecord::Migration[5.2]
  def change
    add_column :inspections, :date, :date
  end
end
