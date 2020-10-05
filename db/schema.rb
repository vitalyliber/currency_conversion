# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_05_084842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currency_symbols", force: :cascade do |t|
    t.string "short"
    t.string "long"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rates", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "to_currency_symbol_id"
    t.bigint "from_currency_symbol_id"
    t.index ["from_currency_symbol_id"], name: "index_rates_on_from_currency_symbol_id"
    t.index ["to_currency_symbol_id"], name: "index_rates_on_to_currency_symbol_id"
  end

end
