class AddShippingOrderIdItemReference < ActiveRecord::Migration[6.1]
  def change
    add_reference :item_references, :shipping_order, foreign_key: true
  end
end
