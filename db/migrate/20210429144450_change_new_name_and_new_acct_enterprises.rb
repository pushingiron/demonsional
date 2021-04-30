class ChangeNewNameAndNewAcctEnterprises < ActiveRecord::Migration[6.1]
  def change
    rename_column :enterprises, :new_name, :enterprise_name
    rename_column :enterprises, :new_acct, :customer_account
  end
end
