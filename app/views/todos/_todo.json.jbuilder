json.extract! todo, :id, :title, :description, :completed, :label, :deadline, :responsible, :created_by, :detail, :plant_id, :created_at, :updated_at
json.url todo_url(todo, format: :json)
