class AddUsersFkColToContracts < ActiveRecord::Migration[6.1]
  def change
    add_reference :contracts, :user, foreign_key: true
  end
end
