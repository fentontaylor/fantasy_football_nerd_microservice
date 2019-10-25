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

ActiveRecord::Schema.define(version: 2019_10_23_003836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projections", force: :cascade do |t|
    t.integer "week"
    t.integer "playerId"
    t.string "position"
    t.float "passAtt"
    t.float "passCmp"
    t.float "passYds"
    t.float "passTD"
    t.float "passInt"
    t.float "rushAtt"
    t.float "rushYds"
    t.float "rushTD"
    t.float "fumblesLost"
    t.float "receptions"
    t.float "recYds"
    t.float "recTD"
    t.float "fg"
    t.float "fgAtt"
    t.float "xp"
    t.float "defInt"
    t.float "defFR"
    t.float "defFF"
    t.float "defSack"
    t.float "defTD"
    t.float "defRetTD"
    t.float "defSafety"
    t.float "defPA"
    t.float "defYdsAllowed"
    t.string "displayName"
    t.string "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
