class RenameHazmatContact < ActiveRecord::Migration[6.1]
  def change
    rename_column :items, :hazmat_contac_name, :hazmat_contact_name
  end
end
