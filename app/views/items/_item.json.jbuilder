json.extract! item, :id, :type, :sequence, :line_number, :description, :freight_class, :weight, :weight_uom, :quantity, :quantity_uom, :cube, :cube_uom, :shipping_orders, :created_at, :updated_at
json.url item_url(item, format: :json)
