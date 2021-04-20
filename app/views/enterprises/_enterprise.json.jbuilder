json.extract! enterprise, :id, :new_name, :new_acct, :parent, :active, :location_code, :location_name,
                                      :address_1, :address_2, :city, :state, :postal, :country, :user_id, :created_at,
                                      :updated_at
json.url enterprise_url(enterprise, format: :json)
