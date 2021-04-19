class RenameTypeToShipUnitTypeInItems < ActiveRecord::Migration[6.1]
  def change
    rename_column :items, :type, :ship_unit
  end
end
