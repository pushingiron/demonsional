json.extract! location, :id, :loc_code, :name, :address1, :address2, :city, :state, :postal, :country, :geo, :residential, :comments, :earliest_appt, :latest_appt, :reference, :created_at, :updated_at
json.url location_url(location, format: :json)
