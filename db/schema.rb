# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100307224706) do

  create_table "check_props", :force => true do |t|
    t.boolean  "checked",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email", :null => false
    t.string   "token",           :null => false
    t.datetime "sent_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "nodes", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "prop_id"
    t.string   "prop_type"
    t.integer  "version",    :default => 0
    t.integer  "pile_id"
  end

  create_table "note_props", :force => true do |t|
    t.text     "note",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pile_ref_props", :force => true do |t|
    t.integer  "ref_pile_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "piles", :force => true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",         :limit => 100,                   :null => false
    t.boolean  "expanded",                    :default => true
    t.integer  "root_node_id"
  end

  create_table "priority_props", :force => true do |t|
    t.integer  "priority",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shares", :force => true do |t|
    t.integer  "sharee_id"
    t.integer  "pile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "authorized", :default => false
    t.boolean  "public",     :default => false
  end

  create_table "tag_props", :force => true do |t|
    t.string   "tag",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_props", :force => true do |t|
    t.string   "text",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_props", :force => true do |t|
    t.datetime "time",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                         :limit => 40
    t.string   "name",                          :limit => 100, :default => ""
    t.string   "email",                         :limit => 100
    t.string   "crypted_password",              :limit => 128, :default => "", :null => false
    t.string   "password_salt",                 :limit => 128, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "old_remember_token",            :limit => 40
    t.datetime "old_remember_token_expires_at"
    t.integer  "invite_id"
    t.integer  "invite_limit"
    t.integer  "invite_sent_count",                            :default => 0,  :null => false
    t.integer  "login_count",                                  :default => 0,  :null => false
    t.integer  "failed_login_count",                           :default => 0,  :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "persistence_token",                                            :null => false
    t.string   "single_access_token",                                          :null => false
    t.string   "perishable_token",                                             :null => false
    t.integer  "root_pile_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
