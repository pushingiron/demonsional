class AddEquipmentCodeShippingOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :shipping_orders, :equipment_code, :string
  end
end
