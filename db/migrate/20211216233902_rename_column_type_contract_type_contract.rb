class RenameColumnTypeContractTypeContract < ActiveRecord::Migration[6.1]
  def change
    rename_column :contracts, :type, :contract_type
  end
end
