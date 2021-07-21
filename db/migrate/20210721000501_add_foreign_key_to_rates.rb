class AddForeignKeyToRates < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :rates, :users
  end
end
