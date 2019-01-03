class CreateSystemSurfaces < ActiveRecord::Migration[5.2]
  def change
    create_table :system_surfaces do |t|
      t.string :option

      t.timestamps
    end
  end
end
