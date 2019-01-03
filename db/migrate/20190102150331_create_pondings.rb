class CreatePondings < ActiveRecord::Migration[5.2]
  def change
    create_table :pondings do |t|
      t.string :option

      t.timestamps
    end
  end
end
