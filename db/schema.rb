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

ActiveRecord::Schema.define(version: 20160726041412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hals", force: :cascade do |t|
    t.text "saved_zips"
    t.text "unsaved_zips"
  end

  create_table "listings", force: :cascade do |t|
    t.string   "name"
    t.string   "business_types"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "cross_streets"
    t.string   "neighborhoods"
    t.string   "phone"
    t.string   "website"
    t.text     "from_the_business"
    t.text     "hours"
    t.text     "specialties"
    t.text     "history"
    t.text     "meet_the_business_owner"
    t.string   "business_owner"
    t.float    "overall_rating"
    t.float    "health_inspection"
    t.string   "yelp_website"
    t.boolean  "takeout"
    t.boolean  "delivery"
    t.boolean  "accepts_credit_cards"
    t.boolean  "accepts_apple_pay"
    t.string   "parking"
    t.boolean  "bike_parking"
    t.boolean  "wheelchair_accessible"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "author"
    t.text     "content"
    t.integer  "listing_id"
    t.float    "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
