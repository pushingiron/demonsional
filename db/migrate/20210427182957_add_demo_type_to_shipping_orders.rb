class AddDemoTypeToShippingOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :shipping_orders, :demo_type, :string
  end
end
