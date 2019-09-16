class CreateSamplings < ActiveRecord::Migration[5.2]
  def change
    create_table :samplings do |t|
      t.references :standard, foreign_key: true
      t.references :sampling_list, foreign_key: true
      t.integer :value_in
      t.integer :value_out
      t.date :date

      t.timestamps
    end
  end
end
