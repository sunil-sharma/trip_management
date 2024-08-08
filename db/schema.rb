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

ActiveRecord::Schema.define(version: 20240808042232) do

  create_table "trip_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.bigint "trip_id"
    t.bigint "owner_id", null: false
    t.bigint "assignee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_trip_versions_on_assignee_id"
    t.index ["owner_id"], name: "index_trip_versions_on_owner_id"
    t.index ["trip_id"], name: "index_trip_versions_on_trip_id"
  end

  create_table "trips", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.datetime "estimated_arrival"
    t.datetime "estimated_completion"
    t.string "status"
    t.datetime "check_in_time"
    t.datetime "check_out_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3" do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "trip_versions", "trips"
  add_foreign_key "trip_versions", "users", column: "assignee_id"
  add_foreign_key "trip_versions", "users", column: "owner_id"
end
