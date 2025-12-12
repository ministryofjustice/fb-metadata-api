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

ActiveRecord::Schema[7.2].define(version: 2025_12_15_180114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", null: false
    t.string "created_by", null: false
    t.string "component_id", null: false
    t.uuid "service_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["component_id"], name: "index_items_on_component_id"
    t.index ["service_id"], name: "index_items_on_service_id"
  end

  create_table "metadata", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", null: false
    t.string "created_by", null: false
    t.string "locale"
    t.uuid "service_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by"], name: "index_metadata_on_created_by"
    t.index ["locale"], name: "index_metadata_on_locale"
    t.index ["service_id"], name: "index_metadata_on_service_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "new_form_reason", null: false
    t.boolean "govuk_forms_ruled_out"
    t.jsonb "required_moj_forms_features"
    t.text "govuk_forms_ruled_out_reason"
    t.boolean "continue_with_moj_forms"
    t.string "estimated_page_count"
    t.string "estimated_first_year_submissions_count"
    t.string "submission_delivery_method"
    t.uuid "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_questionnaires_on_service_id"
  end

  create_table "services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "created_by", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by"], name: "index_services_on_created_by"
    t.index ["name"], name: "index_services_on_name", unique: true
  end

  add_foreign_key "items", "services"
  add_foreign_key "metadata", "services"
  add_foreign_key "questionnaires", "services"
end
