class ChangeUnitNumberToBeArrayInPlant < ActiveRecord::Migration[5.2]
  def change
    change_column :plants, :unit_number, :string, using: "(string_to_array(unit_number, ','))"
  end
end
