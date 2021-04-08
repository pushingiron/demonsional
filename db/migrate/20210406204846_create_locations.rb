class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :loc_type
      t.string :loc_code
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :postal
      t.string :country
      t.string :geo
      t.boolean :residential
      t.string :comments
      t.date :earliest_appt
      t.date :latest_appt
      t.references :user

      t.timestamps
    end
  end
end
