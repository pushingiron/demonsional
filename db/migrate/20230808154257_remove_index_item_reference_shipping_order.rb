class RemoveIndexItemReferenceShippingOrder < ActiveRecord::Migration[6.1]
  def change
    remove_index :item_references, name: "index_item_references_on_shipping_order_id"
  end
end
