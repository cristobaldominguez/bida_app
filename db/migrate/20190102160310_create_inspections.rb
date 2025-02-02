class CreateInspections < ActiveRecord::Migration[5.2]
  def change
    create_table :inspections do |t|
      t.boolean :active, default: true
      t.references :user, foreign_key: true
      t.references :plant, foreign_key: true
      t.boolean :on_site_client
      t.references :screen, foreign_key: true
      t.references :collection_bin, foreign_key: true
      t.text :screen_comments
      t.references :noise, foreign_key: true
      t.text :pumps_noise_description
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
