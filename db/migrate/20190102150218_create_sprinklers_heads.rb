class CreateSprinklersHeads < ActiveRecord::Migration[5.2]
  def change
    create_table :sprinklers_heads do |t|
      t.string :option

      t.timestamps
    end
  end
end
