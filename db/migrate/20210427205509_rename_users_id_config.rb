class RenameUsersIdConfig < ActiveRecord::Migration[6.1]
  def change
    rename_column :configs, :users_id, :user_id
  end
end
