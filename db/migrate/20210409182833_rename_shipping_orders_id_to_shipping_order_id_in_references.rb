class RenameShippingOrdersIdToShippingOrderIdInReferences < ActiveRecord::Migration[6.1]

    def up
    rename_column :references, :shipping_orders_id, :shipping_order_id
    end

    def down
      rename_column :references, :shipping_order_id, :shipping_orders_id
    end

end
