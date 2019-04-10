class CreateFluents < ActiveRecord::Migration[5.2]
  def change
    create_table :fluents do |t|
      t.references :inspection, foreign_key: true
      t.references :output, foreign_key: true
      t.float :ph
      t.references :color, foreign_key: true
      t.text :color_description
      t.references :odor, foreign_key: true
      t.text :odor_description
      t.float :cod
      t.float :ec
      t.float :bod
      t.float :tss
      t.float :tn
      t.float :tp
      t.text :sample_comments

      t.timestamps
    end
  end
end
