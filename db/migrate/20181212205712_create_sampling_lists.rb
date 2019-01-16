class CreateSamplingLists < ActiveRecord::Migration[5.2]
  def change
    create_table :sampling_lists do |t|
      t.references :plant, foreign_key: true
      t.references :access, foreign_key: true
      t.references :frecuency, foreign_key: true
      t.integer :per_cycle

      t.timestamps
    end
  end
end
