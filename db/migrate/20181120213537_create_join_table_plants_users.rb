class CreateJoinTablePlantsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :plants, :users do |t|
      # t.index [:plant_id, :user_id]
      # t.index [:user_id, :plant_id]
    end
  end
end
