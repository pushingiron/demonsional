class ChangeStopTypeEnterprises < ActiveRecord::Migration[6.1]
  def change
    rename_column :enterprises, :stop_type, :location_type
  end
end
