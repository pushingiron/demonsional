class AddWeightPlanToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :weight_plan, :decimal
    add_column :items, :weight_delivered, :integer
    add_column :items, :country_of_origin, :string
    add_column :items, :country_of_manufacture, :string
    add_column :items, :customs_value, :decimal
    add_column :items, :customs_value_currency, :string
    add_column :items, :origination_country, :string
    add_column :items, :manufacturing_country, :string
  end
end
