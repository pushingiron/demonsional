class RenameEnterpriseEnterpriseNameCompanyName < ActiveRecord::Migration[6.1]
  def change
    rename_column :enterprises, :enterprise_name, :company_name
  end
end
