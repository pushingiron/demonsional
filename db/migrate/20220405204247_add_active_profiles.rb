class AddActiveProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :active, :boolean
  end
end
