class CreateOdors < ActiveRecord::Migration[5.2]
  def change
    create_table :odors do |t|
      t.string :option

      t.timestamps
    end
  end
end
