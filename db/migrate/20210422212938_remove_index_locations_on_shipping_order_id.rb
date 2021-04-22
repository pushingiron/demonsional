class RemoveIndexLocationsOnShippingOrderId < ActiveRecord::Migration[6.1]
  def change
    remove_index :locations, :shipping_order_id, :column => :shipping_order_id
  end
end
