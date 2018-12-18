class CreateBounds < ActiveRecord::Migration[5.2]
  def change
    create_table :bounds do |t|
      t.references :standard, foreign_key: true
      t.references :outlet, foreign_key: true
      t.float :from
      t.float :to
      t.boolean :active

      t.timestamps
    end
  end
end
