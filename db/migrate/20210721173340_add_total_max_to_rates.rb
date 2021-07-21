class AddTotalMaxToRates < ActiveRecord::Migration[6.1]
  def change
    add_column :rates, :total_max, :numeric
  end
end
