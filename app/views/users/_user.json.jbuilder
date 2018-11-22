json.extract! user, :id, :name, :lastname, :email, :active, :address01, :address02, :phone, :mobile, :created_at, :updated_at
json.url user_url(user, format: :json)
