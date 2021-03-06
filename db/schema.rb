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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150413095040) do

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "user_id",    limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "kind",       limit: 4
    t.integer  "semester",   limit: 4,   default: 1, null: false
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "student_id",     limit: 4,                 null: false
    t.integer  "lesson_id",      limit: 4,                 null: false
    t.boolean  "flag",           limit: 1, default: false, null: false
    t.date     "date",                                     null: false
    t.integer  "block",          limit: 4, default: 1,     null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "transaction_id", limit: 4,                 null: false
  end

  add_index "logs", ["lesson_id"], name: "logs_lesson_idx", using: :btree
  add_index "logs", ["student_id", "flag", "block"], name: "logs_student_id_flag_block", using: :btree

  create_table "medical_certificates", force: :cascade do |t|
    t.integer  "student_id", limit: 4, null: false
    t.integer  "semester",   limit: 4, null: false
    t.date     "from",                 null: false
    t.date     "till",                 null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "current_semester", limit: 4,   default: 1, null: false
    t.integer  "current_block",    limit: 4,   default: 1, null: false
    t.date     "threshold_date"
    t.integer  "group_id",         limit: 4,               null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "vk_group",         limit: 255
  end

  create_table "students", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "name",                   limit: 255,              null: false
    t.string   "role",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
