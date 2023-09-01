class RemoveforeignKeyItemReferenceShippingOrder < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :item_references, :shipping_orders
  end
end
