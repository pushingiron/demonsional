class RemoveIndexShippingOrderDatesOnShippingOrderId < ActiveRecord::Migration[6.1]
  def change
    remove_reference :shipping_order_dates, :shipping_orders
    add_reference :shipping_order_dates, :locations, index: true
  end
end
