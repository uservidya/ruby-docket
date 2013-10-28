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

ActiveRecord::Schema.define(version: 20131028155316) do

  create_table "comments", force: true do |t|
    t.text     "body",       null: false
    t.datetime "deleted_at"
    t.integer  "task_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry"
  add_index "comments", ["task_id"], name: "index_comments_on_task_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "projects", force: true do |t|
    t.string   "name",         null: false
    t.date     "due_date"
    t.datetime "completed_at"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["team_id"], name: "index_projects_on_team_id"

  create_table "tasks", force: true do |t|
    t.string   "name",         null: false
    t.text     "body"
    t.float    "estimate"
    t.datetime "completed_at"
    t.integer  "project_id",   null: false
    t.integer  "reporter_id",  null: false
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "tasks", ["ancestry"], name: "index_tasks_on_ancestry"
  add_index "tasks", ["owner_id"], name: "index_tasks_on_owner_id"
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id"
  add_index "tasks", ["reporter_id"], name: "index_tasks_on_reporter_id"

  create_table "teams", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",                                null: false
    t.integer  "team_id",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["team_id"], name: "index_users_on_team_id"

end
