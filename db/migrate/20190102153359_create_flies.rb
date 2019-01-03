class CreateFlies < ActiveRecord::Migration[5.2]
  def change
    create_table :flies do |t|
      t.string :option

      t.timestamps
    end
  end
end
