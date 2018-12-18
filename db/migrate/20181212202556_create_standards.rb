class CreateStandards < ActiveRecord::Migration[5.2]
  def change
    create_table :standards do |t|
      t.references :option, foreign_key: true
      t.references :plant, foreign_key: true
      t.boolean :active, default: true
      t.boolean :enabled, default: true
      t.boolean :isRange, default: false

      t.timestamps
    end
  end
end
