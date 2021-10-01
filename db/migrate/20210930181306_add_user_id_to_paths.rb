class AddUserIdToPaths < ActiveRecord::Migration[6.1]
  def change
    add_column :paths, :user_id, :integer
  end
end
