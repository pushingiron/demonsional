class AddBreakFieldsToRates < ActiveRecord::Migration[6.1]
  def change
    add_column :rates, :break_2_field, :string
    add_column :rates, :break_2_min, :numeric
    add_column :rates, :break_2_max, :numeric
  end
end
