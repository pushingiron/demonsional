class AddSmcMinimumToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :smc_minimum, :decimal
  end
end
