json.extract! alert, :id, :user_id, :plant_id, :incident_id, :status_id, :priority_id, :incident_description, :negative_impact, :solution, :incident_resolution, :solution_target_date, :technician_hours_required, :created_at, :updated_at
json.url alert_url(alert, format: :json)
