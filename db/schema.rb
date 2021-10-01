# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_30_181306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configurations", force: :cascade do |t|
    t.string "parent"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "so_match"
    t.string "shipment_match"
    t.index ["user_id"], name: "index_configurations_on_user_id"
  end

  create_table "enterprises", force: :cascade do |t|
    t.string "company_name"
    t.string "customer_account"
    t.boolean "active"
    t.string "location_code"
    t.string "location_name"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "postal"
    t.string "country"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "residential"
    t.string "comments"
    t.time "earliest_appt"
    t.time "latest_appt"
    t.string "location_type"
    t.string "contact_type"
    t.string "contact_name"
    t.string "contact_phone"
    t.string "contact_fax"
    t.string "contact_email"
    t.index ["user_id"], name: "index_enterprises_on_user_id"
  end

  create_table "external_carriers", force: :cascade do |t|
    t.string "name"
    t.string "scac"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "sequence"
    t.integer "line_number"
    t.string "description"
    t.string "freight_class"
    t.float "weight_actual"
    t.string "weight_uom"
    t.float "quantity"
    t.string "quantity_uom"
    t.float "cube"
    t.string "cube_uom"
    t.bigint "shipping_order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "ship_unit"
    t.decimal "weight_plan"
    t.decimal "weight_delivered"
    t.string "country_of_origin"
    t.string "country_of_manufacture"
    t.decimal "customs_value"
    t.string "customs_value_currency"
    t.string "origination_country"
    t.string "manufacturing_country"
    t.string "item_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "loc_type"
    t.string "loc_code"
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "postal"
    t.string "country"
    t.string "geo"
    t.boolean "residential"
    t.string "comments"
    t.date "earliest_appt"
    t.date "latest_appt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "shipping_order_id"
    t.string "stop_type"
  end

  create_table "paths", force: :cascade do |t|
    t.text "description"
    t.string "object"
    t.string "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "rates", force: :cascade do |t|
    t.integer "user_id"
    t.string "contract_id"
    t.string "lane_calc"
    t.string "from_loccode"
    t.string "from_city"
    t.string "from_state"
    t.string "from_zip"
    t.string "from_country"
    t.string "to_loccode"
    t.string "to_city"
    t.string "to_state"
    t.string "to_zip"
    t.string "to_country"
    t.string "scac"
    t.string "service"
    t.string "mode"
    t.string "break_1_field"
    t.decimal "break_1_min"
    t.decimal "break_1_max"
    t.string "rate_field"
    t.string "rate_calc"
    t.decimal "rate"
    t.string "accessorial1_field"
    t.string "accessorial1_calc"
    t.decimal "accessorial1_rate"
    t.decimal "total_min"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "break_2_field"
    t.decimal "break_2_min"
    t.decimal "break_2_max"
    t.decimal "total_max"
  end

  create_table "references", force: :cascade do |t|
    t.string "reference_type"
    t.string "reference_value"
    t.boolean "is_primary"
    t.bigint "shipping_order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shipping_orders", force: :cascade do |t|
    t.string "payment_method"
    t.string "cust_acct_num"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "so_match_ref"
    t.string "shipment_match_ref"
    t.datetime "early_pickup_date"
    t.datetime "late_pickup_date"
    t.datetime "early_delivery_date"
    t.datetime "late_delivery_date"
    t.string "demo_type"
    t.string "equipment_code"
    t.index ["user_id"], name: "index_shipping_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false, null: false
    t.jsonb "config", default: {}, null: false
    t.index ["config"], name: "index_users_on_config", using: :gin
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "configurations", "users"
  add_foreign_key "enterprises", "users"
  add_foreign_key "items", "shipping_orders"
  add_foreign_key "locations", "shipping_orders"
  add_foreign_key "rates", "users"
  add_foreign_key "references", "shipping_orders"
end
