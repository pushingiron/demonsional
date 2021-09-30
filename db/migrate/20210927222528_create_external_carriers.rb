class CreateExternalCarriers < ActiveRecord::Migration[6.1]
  def change
    create_table :external_carriers do |t|
      t.string :name
      t.string :scac
      t.integer :user_id
      t.timestamps
    end
  end
end
