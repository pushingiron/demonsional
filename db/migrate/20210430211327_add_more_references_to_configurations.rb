class AddMoreReferencesToConfigurations < ActiveRecord::Migration[6.1]
  def change
    add_column :configurations, :so_match, :string
    add_column :configurations, :shipment_match, :string
  end
end
