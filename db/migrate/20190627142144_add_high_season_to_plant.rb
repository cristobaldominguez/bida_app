class AddHighSeasonToPlant < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :high_season, :boolean, default: false
  end
end
