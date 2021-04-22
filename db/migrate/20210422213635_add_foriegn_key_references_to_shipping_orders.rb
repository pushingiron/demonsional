class AddForiegnKeyReferencesToShippingOrders < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :references, :shipping_orders
  end
end
