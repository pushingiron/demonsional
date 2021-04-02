class CreateEnterprises < ActiveRecord::Migration[6.1]
  def change
    create_table :enterprises do |t|
      t.string :new_name
      t.string :new_acct
      t.string :parent
      t.boolean :active
      t.string :location_code
      t.string :location_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :postal
      t.string :country
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
