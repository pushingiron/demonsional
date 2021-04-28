class RenameConfigsConfigurations < ActiveRecord::Migration[6.1]
  def change
    rename_table :configs, :configurations
  end
end
