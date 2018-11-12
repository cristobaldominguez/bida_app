class CreateDischargePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :discharge_points do |t|
      t.string :name

      t.timestamps
    end
  end
end
