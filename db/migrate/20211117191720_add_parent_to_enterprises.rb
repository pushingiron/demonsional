class AddParentToEnterprises < ActiveRecord::Migration[6.1]
  def change
    add_column :enterprises, :parent, :string
  end
end
