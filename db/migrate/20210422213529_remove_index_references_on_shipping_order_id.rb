class RemoveIndexReferencesOnShippingOrderId < ActiveRecord::Migration[6.1]
  def change
    remove_index :references, :shipping_order_id, :column => :shipping_order_id
  end
end
