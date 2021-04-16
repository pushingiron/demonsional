class AddSoMatchRefToShippingOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :shipping_orders, :so_match_ref, :string
    add_column :shipping_orders, :shipment_match_ref, :string
  end
end
