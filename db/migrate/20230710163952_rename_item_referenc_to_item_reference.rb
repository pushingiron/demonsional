class RenameItemReferencToItemReference < ActiveRecord::Migration[6.1]
  def change
    rename_table :item_referencs, :item_references
  end
end
