class AddStopTypeToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :stop_type, :string
  end
end
