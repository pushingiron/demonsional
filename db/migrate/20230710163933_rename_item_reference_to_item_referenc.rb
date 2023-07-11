class RenameItemReferenceToItemReferenc < ActiveRecord::Migration[6.1]
  def change
    rename_table :item_references, :item_referencs
  end
end
