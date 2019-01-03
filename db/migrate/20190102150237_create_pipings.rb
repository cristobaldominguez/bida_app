class CreatePipings < ActiveRecord::Migration[5.2]
  def change
    create_table :pipings do |t|
      t.string :option

      t.timestamps
    end
  end
end
