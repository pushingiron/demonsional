class AddRateTableMultipleColumns < ActiveRecord::Migration[6.1]
  def change
    add_column :rates, :max_stops, :integer
    add_column :rates, :transit_method, :string
    add_column :rates, :transit_value, :integer
  end
end
