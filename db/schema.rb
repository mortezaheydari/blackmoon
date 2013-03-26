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

ActiveRecord::Schema.define(:version => 20130325101445) do

  create_table "accounts", :force => true do |t|
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

  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["reset_password_token"], :name => "index_accounts_on_reset_password_token", :unique => true

  create_table "act_administrations", :force => true do |t|
    t.integer  "administrator_id"
    t.integer  "act_id"
    t.string   "act_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "act_creations", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "act_id"
    t.string   "act_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "act_memberships", :force => true do |t|
    t.integer  "member_id"
    t.integer  "act_id"
    t.string   "act_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "album_photos", :force => true do |t|
    t.integer  "album_id"
    t.integer  "photo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "descreption"
    t.string   "location_type"
    t.string   "custom_address"
    t.string   "category"
    t.datetime "date_and_time"
    t.integer  "tournament_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "duration_type"
    t.time     "time_from"
    t.time     "time_to"
    t.float    "fee"
    t.string   "fee_type"
    t.string   "sport"
    t.integer  "number_of_attendings"
    t.boolean  "team_participation"
  end

  create_table "flaggings", :force => true do |t|
    t.string   "flaggable_type"
    t.integer  "flaggable_id"
    t.string   "flagger_type"
    t.integer  "flagger_id"
    t.string   "flag"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "flaggings", ["flag", "flaggable_type", "flaggable_id"], :name => "index_flaggings_on_flag_and_flaggable_type_and_flaggable_id"
  add_index "flaggings", ["flag", "flagger_type", "flagger_id", "flaggable_type", "flaggable_id"], :name => "access_flag_flaggings"
  add_index "flaggings", ["flaggable_type", "flaggable_id"], :name => "index_flaggings_on_flaggable_type_and_flaggable_id"
  add_index "flaggings", ["flagger_type", "flagger_id", "flaggable_type", "flaggable_id"], :name => "access_flaggings"

  create_table "games", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location_type"
    t.string   "custom_address"
    t.string   "category"
    t.datetime "date_and_time"
    t.integer  "tournament_id"
    t.string   "duration_type"
    t.time     "time_from"
    t.time     "time_to"
    t.float    "fee"
    t.string   "fee_type"
    t.string   "sport"
    t.integer  "number_of_attendings"
    t.boolean  "team_participation"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer  "inviter_id"
    t.string   "inviter_type"
    t.integer  "invited_id"
    t.string   "invited_type"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "state"
    t.text     "message"
    t.datetime "submission_datetime"
    t.datetime "response_datetime"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "logos", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "photo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "offering_administrations", :force => true do |t|
    t.integer  "administrator_id"
    t.string   "offering_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "offering_id"
  end

  create_table "offering_creations", :force => true do |t|
    t.string   "creator_id"
    t.integer  "offering_id"
    t.string   "offering_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "offering_individual_participations", :force => true do |t|
    t.integer  "participator_id"
    t.integer  "offering_id"
    t.string   "offering_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "offering_team_participations", :force => true do |t|
    t.integer  "participator_id"
    t.integer  "offering_id"
    t.string   "offering_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.integer  "phone"
    t.string   "gender"
    t.text     "about"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
  end

  add_index "profiles", ["first_name", "last_name"], :name => "index_profiles_on_first_name_and_last_name"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id", "follower_id"], :name => "index_relationships_on_followed_id_and_follower_id", :unique => true
  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "teams", :force => true do |t|
    t.string   "title"
    t.text     "descreption"
    t.string   "sport"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "number_of_attendings"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "account_id"
  end

  add_index "users", ["account_id"], :name => "index_users_on_account_id"
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
