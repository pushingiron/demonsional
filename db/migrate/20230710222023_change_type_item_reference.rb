class ChangeTypeItemReference < ActiveRecord::Migration[6.1]
  def change
    rename_column :item_references, :type, :reference_type
    rename_column :item_references, :value, :reference_value
  end
end
