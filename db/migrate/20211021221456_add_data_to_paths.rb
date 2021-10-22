class AddDataToPaths < ActiveRecord::Migration[6.1]
  def change
    add_column :paths, :data, :xml
  end
end
