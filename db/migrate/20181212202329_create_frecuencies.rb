class CreateFrecuencies < ActiveRecord::Migration[5.2]
  def change
    create_table :frecuencies do |t|
      t.string :name

      t.timestamps
    end
  end
end
