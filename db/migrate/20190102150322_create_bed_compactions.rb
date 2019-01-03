class CreateBedCompactions < ActiveRecord::Migration[5.2]
  def change
    create_table :bed_compactions do |t|
      t.string :option

      t.timestamps
    end
  end
end
