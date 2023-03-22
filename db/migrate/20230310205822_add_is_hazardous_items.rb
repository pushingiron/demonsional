class AddIsHazardousItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :is_hazardous, :boolean
    add_column :items, :proper_shipping_name, :string
    add_column :items, :hazmat_un_na, :string
    add_column :items, :hazmat_group, :string
    add_column :items, :hazmat_class, :string
    add_column :items, :hazmat_ems_number, :string
    add_column :items, :hazmat_contac_name, :string
    add_column :items, :hazmat_contact_phone, :string
    add_column :items, :hazmat_is_placard, :boolean
    add_column :items, :hazmat_placard_details, :string
    add_column :items, :hazmat_flashpoint, :decimal
    add_column :items, :hazmat_flashpoint_uom, :string
    add_column :items, :hazmat_comments, :text
  end
end
