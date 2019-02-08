class CreateInputTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :input_types do |t|
      t.string :option, null: false

      t.timestamps
    end
  end
end
