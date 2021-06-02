class RenameColumnItemsWeightActualWeight < ActiveRecord::Migration[6.1]
  def change
    rename_column :items, :weight, :weight_actual
  end
end
