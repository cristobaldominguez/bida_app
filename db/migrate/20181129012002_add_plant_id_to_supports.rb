class AddPlantIdToSupports < ActiveRecord::Migration[5.2]
  def change
    add_reference :supports, :plant, foreign_key: true
  end
end
