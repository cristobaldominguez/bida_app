class CreateScreens < ActiveRecord::Migration[5.2]
  def change
    create_table :screens do |t|
      t.string :option

      t.timestamps
    end
  end
end
