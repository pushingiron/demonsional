class AddItemIdItem < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :item_id, :string
  end
end
