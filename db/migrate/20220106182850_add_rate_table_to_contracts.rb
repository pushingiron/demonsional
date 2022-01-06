class AddRateTableToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :rate_table, :text
  end
end
