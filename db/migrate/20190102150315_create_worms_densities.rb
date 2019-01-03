class CreateWormsDensities < ActiveRecord::Migration[5.2]
  def change
    create_table :worms_densities do |t|
      t.string :option

      t.timestamps
    end
  end
end
