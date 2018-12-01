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

ActiveRecord::Schema.define(version: 2018_11_30_142714) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "readings", force: :cascade do |t|
    t.string "number"
    t.float "temperature"
    t.float "humidity"
    t.float "battery_charge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "thermostat_id"
    t.index ["number"], name: "index_readings_on_number"
    t.index ["thermostat_id"], name: "index_readings_on_thermostat_id"
  end

  create_table "thermostats", force: :cascade do |t|
    t.string "household_token"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_readings", default: 0
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.float "max_temperature", default: -1000.0
    t.float "min_temperature", default: 1000.0
    t.float "max_battery_charge", default: -100000.0
    t.float "min_battery_charge", default: 100000.0
    t.float "max_humidity", default: 0.0
    t.float "min_humidity", default: 100.0
    t.float "average_humidity", default: 0.0
    t.float "average_temperature", default: 0.0
    t.float "average_battery_charge", default: 0.0
  end

  add_foreign_key "readings", "thermostats"
end
