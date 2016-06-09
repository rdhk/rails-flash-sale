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

ActiveRecord::Schema.define(version: 20160609072839) do

  create_table "deals", force: :cascade do |t|
    t.string   "title",            limit: 255,                   null: false
    t.text     "description",      limit: 65535
    t.integer  "price",            limit: 4
    t.integer  "discounted_price", limit: 4
    t.integer  "quantity",         limit: 4
    t.date     "publish_date"
    t.boolean  "publishable",                    default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "creator_id",       limit: 4
    t.integer  "publisher_id",     limit: 4
    t.boolean  "live",                           default: false
  end

  add_index "deals", ["creator_id"], name: "index_deals_on_creator_id", using: :btree
  add_index "deals", ["publisher_id"], name: "index_deals_on_publisher_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.integer  "deal_id",           limit: 4
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "order_id", limit: 4
    t.integer "deal_id",  limit: 4
  end

  add_index "line_items", ["deal_id"], name: "index_line_items_on_deal_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "status",     limit: 4, default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                    limit: 255,                 null: false
    t.string   "last_name",                     limit: 255,                 null: false
    t.string   "email",                         limit: 255,                 null: false
    t.string   "password_digest",               limit: 255,                 null: false
    t.boolean  "admin",                                     default: false
    t.string   "verification_token",            limit: 255
    t.datetime "verification_token_expires_at"
    t.datetime "verified_at"
    t.string   "password_change_token",         limit: 255
    t.datetime "password_token_expires_at"
    t.string   "remember_me_token",             limit: 255
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
