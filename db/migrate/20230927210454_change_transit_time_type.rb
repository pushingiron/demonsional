class ChangeTransitTimeType < ActiveRecord::Migration[6.1]
  def change
    remove_column :contracts, :transit_time
    add_column :contracts, :transit_time, :string
  end
end
