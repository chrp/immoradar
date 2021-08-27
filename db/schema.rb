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

ActiveRecord::Schema.define(version: 2021_08_27_195941) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ads", force: :cascade do |t|
    t.string "platform", null: false
    t.string "platform_key", null: false
    t.text "url", null: false
    t.string "url_md5", null: false
    t.float "lat"
    t.float "lon"
    t.boolean "is_ignored", default: false, null: false
    t.boolean "is_favorite", default: false, null: false
    t.datetime "published_at", null: false
    t.string "postcode", null: false
    t.string "category"
    t.string "sub_category"
    t.integer "price"
    t.integer "hausgeld"
    t.boolean "has_commission"
    t.integer "year"
    t.integer "flat_sqm"
    t.integer "property_sqm"
    t.integer "rooms_count"
    t.integer "floor"
    t.integer "price_per_sqm_flat"
    t.integer "price_per_sqm_property"
    t.integer "price_per_room"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_suggested", default: false
    t.index ["is_favorite"], name: "index_ads_on_is_favorite"
    t.index ["is_ignored"], name: "index_ads_on_is_ignored"
    t.index ["lat"], name: "index_ads_on_lat"
    t.index ["lon"], name: "index_ads_on_lon"
    t.index ["published_at"], name: "index_ads_on_published_at"
    t.index ["url_md5"], name: "index_ads_on_url_md5"
  end

end
