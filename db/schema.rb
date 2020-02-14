# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_13_160125) do

  create_table "channels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "page_visits", force: :cascade do |t|
    t.integer "page_id", null: false
    t.integer "visit_id", null: false
    t.integer "sequence"
    t.index ["page_id"], name: "index_page_visits_on_page_id"
    t.index ["visit_id"], name: "index_page_visits_on_visit_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "base_path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "searches", force: :cascade do |t|
    t.string "search_string"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "visitors", force: :cascade do |t|
    t.string "intent_client_id"
    t.string "ga_primary_key"
    t.decimal "ga_full_visitor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "visits", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "device_id", null: false
    t.integer "channel_id", null: false
    t.bigint "ga_visit_id"
    t.integer "ga_visit_number"
    t.datetime "ga_visit_start_at"
    t.datetime "ga_visit_end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["channel_id"], name: "index_visits_on_channel_id"
    t.index ["device_id"], name: "index_visits_on_device_id"
    t.index ["visitor_id"], name: "index_visits_on_visitor_id"
  end

  add_foreign_key "page_visits", "pages"
  add_foreign_key "page_visits", "visits"
  add_foreign_key "visits", "channels"
  add_foreign_key "visits", "devices"
  add_foreign_key "visits", "visitors"
end
