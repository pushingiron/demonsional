class AddShipmentTypeToShippingOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :shipping_orders, :shipment_type, :string
  end
end
