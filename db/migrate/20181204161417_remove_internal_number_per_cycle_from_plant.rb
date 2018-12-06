class RemoveInternalNumberPerCycleFromPlant < ActiveRecord::Migration[5.2]
  def change
    remove_column :plants, :internal_number_per_cycle, :string
  end
end
