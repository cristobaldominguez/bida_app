json.extract! company, :id, :active, :name, :taxid, :created_at, :updated_at
json.url company_url(company, format: :json)
