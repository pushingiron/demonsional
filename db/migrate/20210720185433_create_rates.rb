class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.integer :user_id
      t.string :contract_id
      t.string :lane_calc
      t.string :from_loccode
      t.string :from_city
      t.string :from_state
      t.string :from_zip
      t.string :from_country
      t.string :to_loccode
      t.string :to_city
      t.string :to_state
      t.string :to_zip
      t.string :to_country
      t.string :scac
      t.string :service
      t.string :mode
      t.string :break_1_field
      t.decimal :break_1_min
      t.decimal :break_1_max
      t.string :rate_field
      t.string :rate_calc
      t.decimal :rate
      t.string :accessorial1_field
      t.string :accessorial1_calc
      t.decimal :accessorial1_rate
      t.decimal :total_min

      t.timestamps
    end
  end
end
