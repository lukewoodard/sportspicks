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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111002185951) do

  create_table "picks", :force => true do |t|
    t.integer  "sport_id",    :null => false
    t.date     "game_date"
    t.string   "description"
    t.string   "pick"
    t.boolean  "iswinner"
    t.boolean  "ispush"
    t.boolean  "play"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "picks", ["sport_id"], :name => "index_picks_on_sport_id"

  create_table "sports", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_picks", :force => true do |t|
    t.integer  "pick_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_picks", ["pick_id"], :name => "index_user_picks_on_pick_id"
  add_index "user_picks", ["user_id"], :name => "index_user_picks_on_user_id"

  create_table "user_sports", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.integer  "sport_id",        :null => false
    t.date     "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sports", ["sport_id"], :name => "index_user_sports_on_sport_id"
  add_index "user_sports", ["user_id"], :name => "index_user_sports_on_user_id"

  create_table "user_transaction_items", :force => true do |t|
    t.integer  "sport_id"
    t.integer  "user_transaction_id", :null => false
    t.integer  "weeks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_transaction_items", ["sport_id"], :name => "index_user_transaction_items_on_sport_id"
  add_index "user_transaction_items", ["user_transaction_id"], :name => "index_user_transaction_items_on_user_transaction_id"

  create_table "user_transactions", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.float    "total"
    t.string   "discount_code"
    t.date     "transaction_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_transactions", ["user_id"], :name => "index_user_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
