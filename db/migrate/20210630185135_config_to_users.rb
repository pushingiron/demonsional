class ConfigToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :config, :jsonb, null: false, default: {}
    add_index :users, :config, using: :gin
  end
end
