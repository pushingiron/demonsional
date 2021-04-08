class RemoveIndexLocationsOnUserId < ActiveRecord::Migration[6.1]
  def change
    remove_reference :locations, :user
    add_reference :locations, :shipping_order
  end
end
