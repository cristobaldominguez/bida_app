json.extract! plant, :id, :active, :name, :code, :company_id, :address01, :address02, :state, :zip, :phone, :flow_design, :external_number_per_cycle, :internal_number_per_cycle, :startup_date, :created_at, :updated_at
json.url plant_url(plant, format: :json)
