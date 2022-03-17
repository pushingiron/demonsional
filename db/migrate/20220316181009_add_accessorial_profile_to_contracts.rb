class AddAccessorialProfileToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :accessorial_profile, :string
  end
end
