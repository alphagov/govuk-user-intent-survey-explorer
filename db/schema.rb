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

ActiveRecord::Schema.define(version: 2020_04_29_142737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "event_visits", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "visit_id", null: false
    t.integer "sequence"
    t.index ["event_id"], name: "index_event_visits_on_event_id"
    t.index ["visit_id"], name: "index_event_visits_on_visit_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mentions", force: :cascade do |t|
    t.bigint "phrase_id", null: false
    t.bigint "survey_answer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["phrase_id"], name: "index_mentions_on_phrase_id"
    t.index ["survey_answer_id"], name: "index_mentions_on_survey_answer_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "page_visits", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.bigint "visit_id", null: false
    t.integer "sequence"
    t.index ["page_id"], name: "index_page_visits_on_page_id"
    t.index ["visit_id"], name: "index_page_visits_on_visit_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "base_path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "phrases", force: :cascade do |t|
    t.string "phrase_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer "question_number"
    t.string "question_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "free_text_response"
  end

  create_table "search_visits", force: :cascade do |t|
    t.bigint "search_id", null: false
    t.bigint "visit_id", null: false
    t.integer "sequence"
    t.index ["search_id"], name: "index_search_visits_on_search_id"
    t.index ["visit_id"], name: "index_search_visits_on_visit_id"
  end

  create_table "searches", force: :cascade do |t|
    t.string "search_string"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "survey_answers", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "question_id", null: false
    t.string "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_survey_answers_on_question_id"
    t.index ["survey_id"], name: "index_survey_answers_on_survey_id"
  end

  create_table "survey_user_groups", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "user_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_survey_user_groups_on_survey_id"
    t.index ["user_group_id"], name: "index_survey_user_groups_on_user_group_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.bigint "organisation_id", null: false
    t.bigint "visitor_id", null: false
    t.string "ga_primary_key"
    t.string "intents_client_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string "full_path"
    t.string "section"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organisation_id"], name: "index_surveys_on_organisation_id"
    t.index ["visitor_id"], name: "index_surveys_on_visitor_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "group"
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
    t.bigint "visitor_id", null: false
    t.bigint "device_id", null: false
    t.bigint "channel_id", null: false
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

  add_foreign_key "event_visits", "events"
  add_foreign_key "event_visits", "visits"
  add_foreign_key "mentions", "phrases"
  add_foreign_key "mentions", "survey_answers"
  add_foreign_key "page_visits", "pages"
  add_foreign_key "page_visits", "visits"
  add_foreign_key "search_visits", "searches"
  add_foreign_key "search_visits", "visits"
  add_foreign_key "survey_answers", "questions"
  add_foreign_key "survey_answers", "surveys"
  add_foreign_key "survey_user_groups", "surveys"
  add_foreign_key "survey_user_groups", "user_groups"
  add_foreign_key "surveys", "organisations"
  add_foreign_key "surveys", "visitors"
  add_foreign_key "visits", "channels"
  add_foreign_key "visits", "devices"
  add_foreign_key "visits", "visitors"
end
