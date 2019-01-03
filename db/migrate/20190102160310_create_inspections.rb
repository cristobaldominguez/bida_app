class CreateInspections < ActiveRecord::Migration[5.2]
  def change
    create_table :inspections do |t|
      t.boolean :active
      t.references :user, foreign_key: true
      t.references :plant, foreign_key: true
      t.float :cod
      t.float :ec
      t.float :bod
      t.float :tss
      t.float :tn
      t.float :tp
      t.text :sample_comments
      t.references :screen, foreign_key: true
      t.references :collection_bin, foreign_key: true
      t.text :screen_comments
      t.references :noice, foreign_key: true
      t.text :pumps_noice_description
      t.float :pumps_psi
      t.references :sprinklers_pressure, foreign_key: true
      t.references :sprinklers_head, foreign_key: true
      t.references :piping, foreign_key: true
      t.text :pumps_comments
      t.references :system_surface, foreign_key: true
      t.references :bed_compaction, foreign_key: true
      t.references :ponding, foreign_key: true
      t.text :bida_comments
      t.references :odor, foreign_key: true
      t.text :plant_odor_description
      t.boolean :birds
      t.references :fly, foreign_key: true
      t.text :summary_comments
      t.references :worms_color, foreign_key: true
      t.text :worms_color_description
      t.references :worms_activity, foreign_key: true
      t.text :worms_activity_description
      t.references :worms_density, foreign_key: true

      t.timestamps
    end
  end
end
