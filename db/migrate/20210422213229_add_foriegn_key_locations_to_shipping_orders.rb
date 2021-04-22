class AddForiegnKeyLocationsToShippingOrders < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :locations, :shipping_orders
  end
end
