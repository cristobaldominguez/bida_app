class AddActiveToIncidentType < ActiveRecord::Migration[5.2]
  def change
    add_column :incident_types, :active, :boolean, default: true
  end
end
