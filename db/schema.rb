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

ActiveRecord::Schema.define(version: 2018_12_04_161417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "plant_id"
    t.bigint "incident_type_id"
    t.bigint "status_id"
    t.bigint "priority_id"
    t.text "incident_description"
    t.text "negative_impact"
    t.text "solution"
    t.text "incident_resolution"
    t.date "solution_target_date"
    t.integer "technician_hours_required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["incident_type_id"], name: "index_alerts_on_incident_type_id"
    t.index ["plant_id"], name: "index_alerts_on_plant_id"
    t.index ["priority_id"], name: "index_alerts_on_priority_id"
    t.index ["status_id"], name: "index_alerts_on_status_id"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "name"
    t.string "taxid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "industry_id"
    t.bigint "bf_contact_id"
    t.bigint "contact_id"
    t.index ["bf_contact_id"], name: "index_companies_on_bf_contact_id"
    t.index ["contact_id"], name: "index_companies_on_contact_id"
    t.index ["industry_id"], name: "index_companies_on_industry_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discharge_points", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incident_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plants", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "name"
    t.string "code"
    t.bigint "company_id", null: false
    t.string "address01"
    t.string "address02"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "flow_design"
    t.date "startup_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.bigint "discharge_point_id"
    t.string "system_size"
    t.bigint "bf_contact_id"
    t.bigint "contact_id"
    t.index ["bf_contact_id"], name: "index_plants_on_bf_contact_id"
    t.index ["company_id"], name: "index_plants_on_company_id"
    t.index ["contact_id"], name: "index_plants_on_contact_id"
    t.index ["country_id"], name: "index_plants_on_country_id"
    t.index ["discharge_point_id"], name: "index_plants_on_discharge_point_id"
  end

  create_table "plants_users", id: false, force: :cascade do |t|
    t.bigint "plant_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "priorities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supports", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "number"
    t.date "start_date"
    t.date "end_date"
    t.boolean "client_onsite"
    t.string "name_client_onsite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "plant_id"
    t.bigint "user_id"
    t.index ["plant_id"], name: "index_supports_on_plant_id"
    t.index ["user_id"], name: "index_supports_on_user_id"
  end

  create_table "supports_users", id: false, force: :cascade do |t|
    t.bigint "support_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "lastname", default: "", null: false
    t.string "address01"
    t.string "address02"
    t.string "phone"
    t.string "mobile"
    t.boolean "active", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alerts", "incident_types"
  add_foreign_key "alerts", "plants"
  add_foreign_key "alerts", "priorities"
  add_foreign_key "alerts", "statuses"
  add_foreign_key "alerts", "users"
  add_foreign_key "companies", "industries"
  add_foreign_key "plants", "companies"
  add_foreign_key "plants", "countries"
  add_foreign_key "plants", "discharge_points"
  add_foreign_key "supports", "plants"
  add_foreign_key "supports", "users"
end
