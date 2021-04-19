class RemoveForiegnContraintShippingOrderIdOnReferences < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :references, :shipping_orders
  end
end
