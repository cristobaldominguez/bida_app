class CreatePlants < ActiveRecord::Migration[5.2]
  def change
    create_table :plants do |t|
      t.boolean :active, default: true
      t.string :name
      t.string :code
      t.references :company, foreign_key: true, null: false
      t.string :address01
      t.string :address02
      t.string :state
      t.string :zip
      t.string :phone
      t.integer :flow_design
      t.date :startup_date

      t.timestamps
    end
  end
end
