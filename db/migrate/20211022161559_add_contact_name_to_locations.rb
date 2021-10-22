class AddContactNameToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :contact_name, :string
    add_column :locations, :contact_phone, :string
    add_column :locations, :contact_email, :string
  end
end
