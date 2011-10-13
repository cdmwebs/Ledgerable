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

ActiveRecord::Schema.define(:version => 20110814173949) do

  create_table "categories", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "ledger_id"
  end

  add_index "categories", ["ledger_id"], :name => "index_categories_on_ledger_id"

  create_table "entries", :force => true do |t|
    t.date     "date"
    t.string   "payee"
    t.string   "memo"
    t.float    "amount"
    t.string   "status",             :default => "Open"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "ledger_id"
    t.integer  "recurring_entry_id"
  end

  add_index "entries", ["category_id"], :name => "index_transactions_on_category_id"
  add_index "entries", ["date"], :name => "index_transactions_on_date"
  add_index "entries", ["ledger_id", "date"], :name => "index_entries_on_ledger_id_and_date"
  add_index "entries", ["ledger_id"], :name => "index_transactions_on_ledger_id"
  add_index "entries", ["recurring_entry_id"], :name => "index_entries_on_recurring_entry_id"
  add_index "entries", ["recurring_entry_id"], :name => "index_entries_on_recurring_transaction_id"

  create_table "ledgers", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ledgers", ["user_id"], :name => "index_ledgers_on_user_id"

  create_table "recurring_entries", :force => true do |t|
    t.integer   "ledger_id"
    t.string    "period"
    t.date      "start_date"
    t.float     "amount"
    t.string    "payee"
    t.integer   "times"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "category_id"
    t.string    "memo"
    t.integer   "day_of_month"
  end

  create_table "users", :force => true do |t|
    t.string    "email",                               :default => "",    :null => false
    t.string    "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string    "password_salt",                       :default => "",    :null => false
    t.string    "reset_password_token"
    t.string    "remember_token"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                       :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.string    "authentication_token"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "comped",                              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
