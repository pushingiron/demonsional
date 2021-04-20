class AddEarlyPickupDateToShippingOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :shipping_orders, :early_pickup_date, :datetime
    add_column :shipping_orders, :late_pickup_date, :datetime
    add_column :shipping_orders, :early_delivery_date, :datetime
    add_column :shipping_orders, :late_delivery_date, :datetime
  end
end
