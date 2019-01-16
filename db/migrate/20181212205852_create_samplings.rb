class CreateSamplings < ActiveRecord::Migration[5.2]
  def change
    create_table :samplings do |t|
      t.references :standard, foreign_key: true
      t.float :value_in
      t.float :value_out
      t.references :sampling_list, foreign_key: true

      t.timestamps
    end
  end
end
