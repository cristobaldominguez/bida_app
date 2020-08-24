class ChangeDataTypeForHighSeason < ActiveRecord::Migration[5.2]
  def change
    remove_column :plants, :high_season
    add_column :plants, :high_season, :jsonb, using: 'high_season::jsonb', default: { in: '', out: '' }
  end
end
