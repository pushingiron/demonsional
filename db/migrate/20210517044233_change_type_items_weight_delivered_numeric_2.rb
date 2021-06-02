class ChangeTypeItemsWeightDeliveredNumeric2 < ActiveRecord::Migration[6.1]
  def change
    change_column :items, :weight_delivered, :decimal
    change_column :items, :weight_plan, :decimal
  end
end
