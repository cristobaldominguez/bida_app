class CreateNoises < ActiveRecord::Migration[5.2]
  def change
    create_table :noises do |t|
      t.string :option

      t.timestamps
    end
  end
end
