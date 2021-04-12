class CreateShippingOrderDates < ActiveRecord::Migration[6.1]
  def change
    create_table :shipping_order_dates do |t|
      t.string :date_type
      t.date :date_value
      t.references :shipping_orders, null: false, foreign_key: true

      t.timestamps
    end
  end
end
