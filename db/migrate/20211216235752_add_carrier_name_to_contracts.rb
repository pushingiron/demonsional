class AddCarrierNameToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :carrier_name, :string
    add_column :contracts, :carrier_enterprise, :string
  end
end
