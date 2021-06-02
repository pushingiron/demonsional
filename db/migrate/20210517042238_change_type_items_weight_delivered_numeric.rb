class ChangeTypeItemsWeightDeliveredNumeric < ActiveRecord::Migration[6.1]
  def change
    change_column :items, :weight_delivered, :numeric
  end
end
