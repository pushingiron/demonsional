json.extract! shipping_order, :id, :payment_method, :cust_acct_num, :created_at, :updated_at
json.url shipping_order_url(shipping_order, format: :json)
