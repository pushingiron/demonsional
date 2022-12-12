class AddEnterpriseCustAccNum < ActiveRecord::Migration[6.1]
  def change
    add_column :enterprises, :parent_acct_num, :string
  end
end
