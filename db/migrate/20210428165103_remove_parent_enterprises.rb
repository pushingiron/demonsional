class RemoveParentEnterprises < ActiveRecord::Migration[6.1]
  def change
    remove_column :enterprises, :parent
  end
end
