json.extract! task, :id, :log_type_id, :input_type_id, :name, :created_at, :updated_at
json.url task_url(task, format: :json)
