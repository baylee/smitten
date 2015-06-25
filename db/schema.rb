# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20150625045240) do

  create_table "flags", :force => true do |t|
    t.text     "reason"
    t.string   "flaggable_type"
    t.integer  "flaggable_id"
    t.integer  "flagger_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "services", :force => true do |t|
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "expires_at"
  end

  add_index "services", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "sparks", :force => true do |t|
    t.text     "content"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "location_only",  :default => false
    t.string   "input_location"
    t.string   "title"
  end

  add_index "sparks", ["user_id"], :name => "index_sparks_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
