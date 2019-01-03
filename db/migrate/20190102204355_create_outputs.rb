class CreateOutputs < ActiveRecord::Migration[5.2]
  def change
    create_table :outputs do |t|
      t.string :name

      t.timestamps
    end
  end
end
