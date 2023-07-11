class RemoveItemIdItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :items, :item_id
  end
end
