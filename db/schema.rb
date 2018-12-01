# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_01_145710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "journeys", force: :cascade do |t|
    t.text "title", null: false
    t.text "keywords"
    t.text "published_status", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", null: false
    t.integer "position", default: 0, null: false
  end

  create_table "pages", force: :cascade do |t|
    t.text "title", null: false
    t.text "content", null: false
    t.text "slug", null: false
    t.boolean "is_faq", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "journey_id", null: false
    t.text "title", null: false
    t.text "keywords"
    t.boolean "is_waiting_step", default: false, null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", null: false
    t.integer "position", default: 0, null: false
    t.index ["journey_id"], name: "index_steps_on_journey_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "step_id", null: false
    t.text "title", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "url"
    t.integer "position", default: 0, null: false
    t.index ["step_id"], name: "index_tasks_on_step_id"
  end

  create_table "user_journeys", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "journey_id", null: false
    t.datetime "started_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journey_id"], name: "index_user_journeys_on_journey_id"
    t.index ["user_id"], name: "index_user_journeys_on_user_id"
  end

  create_table "user_steps", force: :cascade do |t|
    t.bigint "user_journey_id", null: false
    t.bigint "step_id", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["step_id"], name: "index_user_steps_on_step_id"
    t.index ["user_journey_id"], name: "index_user_steps_on_user_journey_id"
  end

  create_table "user_tasks", force: :cascade do |t|
    t.bigint "user_step_id", null: false
    t.bigint "task_id", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_user_tasks_on_task_id"
    t.index ["user_step_id"], name: "index_user_tasks_on_user_step_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "steps", "journeys"
  add_foreign_key "tasks", "steps"
  add_foreign_key "user_journeys", "journeys"
  add_foreign_key "user_journeys", "users"
  add_foreign_key "user_steps", "steps"
  add_foreign_key "user_steps", "user_journeys"
  add_foreign_key "user_tasks", "tasks"
  add_foreign_key "user_tasks", "user_steps"
end
