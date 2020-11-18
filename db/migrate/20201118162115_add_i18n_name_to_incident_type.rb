class AddI18nNameToIncidentType < ActiveRecord::Migration[5.2]
  def change
    add_column :incident_types, :i18n_name, :jsonb, default: {}
  end
end
