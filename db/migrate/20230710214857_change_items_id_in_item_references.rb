class ChangeItemsIdInItemReferences < ActiveRecord::Migration[6.1]
  def change
    rename_column :item_references, :items_id, :item_id
  end
end
