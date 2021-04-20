class DropShippingOrderDates < ActiveRecord::Migration[6.1]
  def change
    drop_table :shipping_order_dates
  end
end
