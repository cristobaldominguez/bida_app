class AddUnitNumberToPlant < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :unit_number, :string
  end
end
