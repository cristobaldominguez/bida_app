class RemoveLabNumberPerCycleFromPlant < ActiveRecord::Migration[5.2]
  def change
    remove_column :plants, :lab_number_per_cycle, :string
  end
end
