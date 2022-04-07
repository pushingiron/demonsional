class RemoveConfigUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :config
  end
end
