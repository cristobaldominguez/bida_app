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

ActiveRecord::Schema.define(version: 2019_03_21_132352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accesses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "alerts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "plant_id"
    t.bigint "incident_type_id"
    t.bigint "status_id"
    t.bigint "priority_id"
    t.boolean "active", default: true, null: false
    t.text "incident_description"
    t.text "negative_impact"
    t.text "solution"
    t.text "incident_resolution"
    t.date "solution_target_date"
    t.integer "technician_hours_required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["incident_type_id"], name: "index_alerts_on_incident_type_id"
    t.index ["plant_id"], name: "index_alerts_on_plant_id"
    t.index ["priority_id"], name: "index_alerts_on_priority_id"
    t.index ["status_id"], name: "index_alerts_on_status_id"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "alerts_users", id: false, force: :cascade do |t|
    t.bigint "alert_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "bed_compactions", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bounds", force: :cascade do |t|
    t.bigint "standard_id"
    t.bigint "outlet_id"
    t.float "from"
    t.float "to"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outlet_id"], name: "index_bounds_on_outlet_id"
    t.index ["standard_id"], name: "index_bounds_on_standard_id"
  end

  create_table "charts", force: :cascade do |t|
    t.string "name"
    t.integer "shape"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collection_bins", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colors", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "metric_id"
    t.index ["metric_id"], name: "index_countries_on_metric_id"
  end

  create_table "discharge_points", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flies", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flow_reports", force: :cascade do |t|
    t.bigint "plant_id"
    t.date "date"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_flow_reports_on_plant_id"
  end

  create_table "flows", force: :cascade do |t|
    t.boolean "active", default: true
    t.bigint "plant_id"
    t.float "value", default: 0.0
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "flow_report_id"
    t.index ["flow_report_id"], name: "index_flows_on_flow_report_id"
    t.index ["plant_id"], name: "index_flows_on_plant_id"
  end

  create_table "fluents", force: :cascade do |t|
    t.bigint "inspection_id"
    t.bigint "output_id"
    t.float "ph"
    t.bigint "color_id"
    t.text "color_description"
    t.bigint "odor_id"
    t.text "odor_description"
    t.float "cod"
    t.float "ec"
    t.float "bod"
    t.float "tss"
    t.float "tn"
    t.float "tp"
    t.text "sample_comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id"], name: "index_fluents_on_color_id"
    t.index ["inspection_id"], name: "index_fluents_on_inspection_id"
    t.index ["odor_id"], name: "index_fluents_on_odor_id"
    t.index ["output_id"], name: "index_fluents_on_output_id"
  end

  create_table "frecuencies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "graph_standards", force: :cascade do |t|
    t.bigint "plant_id"
    t.bigint "chart_id"
    t.boolean "active", default: true
    t.boolean "show", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chart_id"], name: "index_graph_standards_on_chart_id"
    t.index ["plant_id"], name: "index_graph_standards_on_plant_id"
  end

  create_table "graphs", force: :cascade do |t|
    t.bigint "report_id"
    t.bigint "graph_standard_id"
    t.boolean "active", default: true
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["graph_standard_id"], name: "index_graphs_on_graph_standard_id"
    t.index ["report_id"], name: "index_graphs_on_report_id"
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

  create_table "input_types", force: :cascade do |t|
    t.string "option", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inspections", force: :cascade do |t|
    t.boolean "active", default: true
    t.bigint "user_id"
    t.bigint "plant_id"
    t.boolean "on_site_client"
    t.bigint "screen_id"
    t.bigint "collection_bin_id"
    t.text "screen_comments"
    t.bigint "noise_id"
    t.text "pumps_noise_description"
    t.float "pumps_psi"
    t.bigint "sprinklers_pressure_id"
    t.bigint "sprinklers_head_id"
    t.bigint "piping_id"
    t.text "pumps_comments"
    t.bigint "system_surface_id"
    t.bigint "bed_compaction_id"
    t.bigint "ponding_id"
    t.text "bida_comments"
    t.bigint "odor_id"
    t.text "plant_odor_description"
    t.boolean "birds"
    t.bigint "fly_id"
    t.text "summary_comments"
    t.bigint "worms_color_id"
    t.text "worms_color_description"
    t.bigint "worms_activity_id"
    t.text "worms_activity_description"
    t.bigint "worms_density_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "on_site_user_id"
    t.bigint "report_technician_id"
    t.index ["bed_compaction_id"], name: "index_inspections_on_bed_compaction_id"
    t.index ["collection_bin_id"], name: "index_inspections_on_collection_bin_id"
    t.index ["fly_id"], name: "index_inspections_on_fly_id"
    t.index ["noise_id"], name: "index_inspections_on_noise_id"
    t.index ["odor_id"], name: "index_inspections_on_odor_id"
    t.index ["on_site_user_id"], name: "index_inspections_on_on_site_user_id"
    t.index ["piping_id"], name: "index_inspections_on_piping_id"
    t.index ["plant_id"], name: "index_inspections_on_plant_id"
    t.index ["ponding_id"], name: "index_inspections_on_ponding_id"
    t.index ["report_technician_id"], name: "index_inspections_on_report_technician_id"
    t.index ["screen_id"], name: "index_inspections_on_screen_id"
    t.index ["sprinklers_head_id"], name: "index_inspections_on_sprinklers_head_id"
    t.index ["sprinklers_pressure_id"], name: "index_inspections_on_sprinklers_pressure_id"
    t.index ["system_surface_id"], name: "index_inspections_on_system_surface_id"
    t.index ["user_id"], name: "index_inspections_on_user_id"
    t.index ["worms_activity_id"], name: "index_inspections_on_worms_activity_id"
    t.index ["worms_color_id"], name: "index_inspections_on_worms_color_id"
    t.index ["worms_density_id"], name: "index_inspections_on_worms_density_id"
  end

  create_table "log_standards", force: :cascade do |t|
    t.bigint "task_id"
    t.bigint "plant_id"
    t.bigint "frecuency_id"
    t.boolean "active", default: true
    t.integer "responsible", default: 0
    t.integer "cycle", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frecuency_id"], name: "index_log_standards_on_frecuency_id"
    t.index ["plant_id"], name: "index_log_standards_on_plant_id"
    t.index ["task_id"], name: "index_log_standards_on_task_id"
  end

  create_table "log_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logbooks", force: :cascade do |t|
    t.bigint "plant_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_logbooks_on_plant_id"
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "logbook_id"
    t.bigint "log_standard_id"
    t.boolean "active", default: true
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["log_standard_id"], name: "index_logs_on_log_standard_id"
    t.index ["logbook_id"], name: "index_logs_on_logbook_id"
  end

  create_table "metric_types", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metrics", force: :cascade do |t|
    t.bigint "metric_type_id"
    t.string "length"
    t.string "volume"
    t.string "area"
    t.string "mass"
    t.string "temperature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_type_id"], name: "index_metrics_on_metric_type_id"
  end

  create_table "noises", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "odors", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outlets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outputs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pipings", force: :cascade do |t|
    t.string "option"
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
    t.integer "flow_design"
    t.date "startup_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.bigint "discharge_point_id"
    t.string "system_size"
    t.bigint "bf_contact_id"
    t.bigint "contact_id"
    t.string "system_purpose"
    t.string "report_preface"
    t.bigint "logbook_bf_responsible_id"
    t.bigint "logbook_bf_supervisor_id"
    t.bigint "logbook_company_responsible_id"
    t.index ["bf_contact_id"], name: "index_plants_on_bf_contact_id"
    t.index ["company_id"], name: "index_plants_on_company_id"
    t.index ["contact_id"], name: "index_plants_on_contact_id"
    t.index ["country_id"], name: "index_plants_on_country_id"
    t.index ["discharge_point_id"], name: "index_plants_on_discharge_point_id"
    t.index ["logbook_bf_responsible_id"], name: "index_plants_on_logbook_bf_responsible_id"
    t.index ["logbook_bf_supervisor_id"], name: "index_plants_on_logbook_bf_supervisor_id"
    t.index ["logbook_company_responsible_id"], name: "index_plants_on_logbook_company_responsible_id"
  end

  create_table "plants_users", id: false, force: :cascade do |t|
    t.bigint "plant_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "pondings", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "priorities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "plant_id"
    t.boolean "active", default: true
    t.integer "state", default: 0
    t.string "system_purpose"
    t.string "report_preface"
    t.string "flow_design"
    t.string "system_size"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_id"], name: "index_reports_on_plant_id"
  end

  create_table "sampling_lists", force: :cascade do |t|
    t.bigint "plant_id"
    t.bigint "access_id"
    t.bigint "frecuency_id"
    t.date "date"
    t.integer "per_cycle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["access_id"], name: "index_sampling_lists_on_access_id"
    t.index ["frecuency_id"], name: "index_sampling_lists_on_frecuency_id"
    t.index ["plant_id"], name: "index_sampling_lists_on_plant_id"
  end

  create_table "samplings", force: :cascade do |t|
    t.bigint "standard_id"
    t.bigint "sampling_list_id"
    t.float "value_in"
    t.float "value_out"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sampling_list_id"], name: "index_samplings_on_sampling_list_id"
    t.index ["standard_id"], name: "index_samplings_on_standard_id"
  end

  create_table "screens", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sprinklers_heads", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sprinklers_pressures", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standards", force: :cascade do |t|
    t.bigint "option_id"
    t.bigint "plant_id"
    t.boolean "active", default: true
    t.boolean "enabled", default: true
    t.boolean "isRange", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_standards_on_option_id"
    t.index ["plant_id"], name: "index_standards_on_plant_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supports", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.date "start_date"
    t.date "end_date"
    t.boolean "client_onsite"
    t.bigint "client_id"
    t.bigint "bf_technician_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "plant_id"
    t.bigint "user_id"
    t.index ["bf_technician_id"], name: "index_supports_on_bf_technician_id"
    t.index ["client_id"], name: "index_supports_on_client_id"
    t.index ["plant_id"], name: "index_supports_on_plant_id"
    t.index ["user_id"], name: "index_supports_on_user_id"
  end

  create_table "supports_users", id: false, force: :cascade do |t|
    t.bigint "support_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "system_surfaces", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "log_type_id"
    t.bigint "input_type_id"
    t.bigint "frecuency_id"
    t.integer "cycle", default: 1, null: false
    t.integer "responsible", default: 0
    t.boolean "active", default: true
    t.string "name", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frecuency_id"], name: "index_tasks_on_frecuency_id"
    t.index ["input_type_id"], name: "index_tasks_on_input_type_id"
    t.index ["log_type_id"], name: "index_tasks_on_log_type_id"
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
    t.integer "role", default: 0
    t.integer "interface_color", default: 0
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_summaries", force: :cascade do |t|
    t.bigint "support_id"
    t.boolean "active", default: true
    t.string "description"
    t.integer "hours"
    t.text "materials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["support_id"], name: "index_work_summaries_on_support_id"
  end

  create_table "worms_activities", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "worms_colors", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "worms_densities", force: :cascade do |t|
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "alerts", "incident_types"
  add_foreign_key "alerts", "plants"
  add_foreign_key "alerts", "priorities"
  add_foreign_key "alerts", "statuses"
  add_foreign_key "alerts", "users"
  add_foreign_key "bounds", "outlets"
  add_foreign_key "bounds", "standards"
  add_foreign_key "companies", "industries"
  add_foreign_key "countries", "metrics"
  add_foreign_key "flow_reports", "plants"
  add_foreign_key "flows", "flow_reports"
  add_foreign_key "flows", "plants"
  add_foreign_key "fluents", "colors"
  add_foreign_key "fluents", "inspections"
  add_foreign_key "fluents", "odors"
  add_foreign_key "fluents", "outputs"
  add_foreign_key "graph_standards", "charts"
  add_foreign_key "graph_standards", "plants"
  add_foreign_key "graphs", "graph_standards"
  add_foreign_key "graphs", "reports"
  add_foreign_key "inspections", "bed_compactions"
  add_foreign_key "inspections", "collection_bins"
  add_foreign_key "inspections", "flies"
  add_foreign_key "inspections", "noises"
  add_foreign_key "inspections", "odors"
  add_foreign_key "inspections", "pipings"
  add_foreign_key "inspections", "plants"
  add_foreign_key "inspections", "pondings"
  add_foreign_key "inspections", "screens"
  add_foreign_key "inspections", "sprinklers_heads"
  add_foreign_key "inspections", "sprinklers_pressures"
  add_foreign_key "inspections", "system_surfaces"
  add_foreign_key "inspections", "users"
  add_foreign_key "inspections", "worms_activities"
  add_foreign_key "inspections", "worms_colors"
  add_foreign_key "inspections", "worms_densities"
  add_foreign_key "log_standards", "frecuencies"
  add_foreign_key "log_standards", "plants"
  add_foreign_key "log_standards", "tasks"
  add_foreign_key "logbooks", "plants"
  add_foreign_key "logs", "log_standards"
  add_foreign_key "logs", "logbooks"
  add_foreign_key "metrics", "metric_types"
  add_foreign_key "plants", "companies"
  add_foreign_key "plants", "countries"
  add_foreign_key "plants", "discharge_points"
  add_foreign_key "reports", "plants"
  add_foreign_key "sampling_lists", "accesses"
  add_foreign_key "sampling_lists", "frecuencies"
  add_foreign_key "sampling_lists", "plants"
  add_foreign_key "samplings", "sampling_lists"
  add_foreign_key "samplings", "standards"
  add_foreign_key "standards", "options"
  add_foreign_key "standards", "plants"
  add_foreign_key "supports", "plants"
  add_foreign_key "supports", "users"
  add_foreign_key "tasks", "frecuencies"
  add_foreign_key "tasks", "input_types"
  add_foreign_key "tasks", "log_types"
  add_foreign_key "work_summaries", "supports"
end
