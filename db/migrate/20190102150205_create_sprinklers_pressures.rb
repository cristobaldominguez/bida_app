class CreateSprinklersPressures < ActiveRecord::Migration[5.2]
  def change
    create_table :sprinklers_pressures do |t|
      t.string :option

      t.timestamps
    end
  end
end
