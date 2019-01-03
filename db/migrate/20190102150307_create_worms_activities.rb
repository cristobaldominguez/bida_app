class CreateWormsActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :worms_activities do |t|
      t.string :option

      t.timestamps
    end
  end
end
