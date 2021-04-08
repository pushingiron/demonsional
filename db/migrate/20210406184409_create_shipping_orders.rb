class CreateShippingOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :shipping_orders do |t|
      t.string :payment_method
      t.string :cust_acct_num
      t.references :user

      t.timestamps
    end
  end
end
