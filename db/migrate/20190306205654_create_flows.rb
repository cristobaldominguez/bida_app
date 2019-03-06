class CreateFlows < ActiveRecord::Migration[5.2]
  def change
    create_table :flows do |t|
      t.float :value
      t.boolean :active, default: true
      t.references :plant, foreign_key: true

      t.timestamps
    end
  end
end
