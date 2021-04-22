class AddForiegnKeyItemsToShippingOrders < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :items, :shipping_orders
  end
end
