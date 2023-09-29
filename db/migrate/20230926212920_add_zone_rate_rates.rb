class AddZoneRateRates < ActiveRecord::Migration[6.1]
  def change
    add_column :rates, :rating_zone, :string
  end
end
