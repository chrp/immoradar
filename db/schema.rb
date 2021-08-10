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

ActiveRecord::Schema.define(version: 2019_08_02_084618) do

  create_table "ads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_favorite"], name: "index_ads_on_is_favorite"
    t.index ["is_ignored"], name: "index_ads_on_is_ignored"
    t.index ["lat"], name: "index_ads_on_lat"
    t.index ["lon"], name: "index_ads_on_lon"
    t.index ["published_at"], name: "index_ads_on_published_at"
    t.index ["url_md5"], name: "index_ads_on_url_md5"
  end

end
