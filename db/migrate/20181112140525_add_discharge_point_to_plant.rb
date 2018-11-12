class AddDischargePointToPlant < ActiveRecord::Migration[5.2]
  def change
    add_reference :plants, :discharge_point, foreign_key: true
  end
end
