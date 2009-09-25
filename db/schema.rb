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

ActiveRecord::Schema.define(:version => 20090925180351) do

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
    t.integer  "pile_id",                   :null => false
  end

  create_table "note_props", :force => true do |t|
    t.text     "note",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "piles", :force => true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priority_props", :force => true do |t|
    t.integer  "priority",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "invite_id",                                                :null => false
    t.integer  "invite_limit"
    t.integer  "invite_sent_count",                        :default => 0,  :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
