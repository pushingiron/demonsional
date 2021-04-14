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

ActiveRecord::Schema.define(version: 2021_04_13_213117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enterprises", force: :cascade do |t|
    t.string "new_name"
    t.string "new_acct"
    t.string "parent"
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
    t.index ["user_id"], name: "index_enterprises_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "type"
    t.integer "sequence"
    t.integer "line_number"
    t.string "description"
    t.string "freight_class"
    t.float "weight"
    t.string "weight_uom"
    t.float "quantity"
    t.string "quantity_uom"
    t.float "cube"
    t.string "cube_uom"
    t.bigint "shipping_order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipping_order_id"], name: "index_items_on_shipping_order_id"
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
    t.index ["shipping_order_id"], name: "index_locations_on_shipping_order_id"
  end

  create_table "references", force: :cascade do |t|
    t.string "reference_type"
    t.string "reference_value"
    t.boolean "is_primary"
    t.bigint "shipping_order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipping_order_id"], name: "index_references_on_shipping_order_id"
  end

  create_table "shipping_order_dates", force: :cascade do |t|
    t.string "date_type"
    t.date "date_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "locations_id"
    t.index ["locations_id"], name: "index_shipping_order_dates_on_locations_id"
  end

  create_table "shipping_orders", force: :cascade do |t|
    t.string "payment_method"
    t.string "cust_acct_num"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enterprises", "users"
  add_foreign_key "references", "shipping_orders"
end
