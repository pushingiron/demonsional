class RemoveIndexItemsOnShippingOrderId < ActiveRecord::Migration[6.1]
  def change
    remove_index :items, :shipping_order_id, :column => :shipping_order_id
  end
end
