class CreateOutlets < ActiveRecord::Migration[5.2]
  def change
    create_table :outlets do |t|
      t.string :name

      t.timestamps
    end
  end
end
