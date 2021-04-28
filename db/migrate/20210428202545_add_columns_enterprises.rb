class AddColumnsEnterprises < ActiveRecord::Migration[6.1]
  def change
    add_column :enterprises, :residential, :boolean
    add_column :enterprises, :comments, :string
    add_column :enterprises, :earliest_appt, :time
    add_column :enterprises, :latest_appt, :time
    add_column :enterprises, :stop_type, :string
    add_column :enterprises, :contact_type, :string
    add_column :enterprises, :contact_name, :string
    add_column :enterprises, :contact_phone, :string
    add_column :enterprises, :contact_fax, :string
    add_column :enterprises, :contact_email, :string
  end
end
