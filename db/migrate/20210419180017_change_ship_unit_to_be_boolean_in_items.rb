class ChangeShipUnitToBeBooleanInItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :items, :ship_unit
    add_column :items, :ship_unit, :boolean
  end
end
