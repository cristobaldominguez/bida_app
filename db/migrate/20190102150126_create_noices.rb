class CreateNoices < ActiveRecord::Migration[5.2]
  def change
    create_table :noices do |t|
      t.string :option

      t.timestamps
    end
  end
end
