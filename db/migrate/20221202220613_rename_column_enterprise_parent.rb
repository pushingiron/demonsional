class RenameColumnEnterpriseParent < ActiveRecord::Migration[6.1]
  def change
    rename_column :enterprises, :parent, :parent_name
  end
end
