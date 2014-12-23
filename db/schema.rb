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

ActiveRecord::Schema.define(version: 20141222002956) do

  create_table "ad_clicks", force: true do |t|
    t.date     "date"
    t.float    "number",       limit: 24
    t.integer  "publisher_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "advertises", force: true do |t|
    t.text     "top_userimage_desktop"
    t.text     "top_userimage_mobile"
    t.text     "top_article_desktop"
    t.text     "top_article_mobile"
    t.text     "bot_homepage_desktop"
    t.text     "bot_homepage_mobile"
    t.text     "bot_popular_desktop"
    t.text     "bot_popular_mobile"
    t.text     "bot_userimage_desktop"
    t.text     "bot_userimage_mobile"
    t.text     "bot_article_desktop"
    t.text     "bot_article_mobile"
    t.text     "side_article_desktop"
    t.text     "side_article_mobile"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "dfp_header_desktop"
    t.text     "dfp_header_mobile"
  end

  create_table "articles", force: true do |t|
    t.string   "title"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "category_id"
    t.integer  "user_id"
    t.boolean  "published",          default: false
    t.date     "publish_date"
    t.text     "intro"
    t.text     "outtro"
    t.text     "cache_thumbnail"
    t.text     "cache_citation"
    t.text     "cache_desc"
    t.integer  "p0",                 default: 0
    t.integer  "p1",                 default: 0
    t.integer  "p2",                 default: 0
    t.integer  "p3",                 default: 0
    t.integer  "p4",                 default: 0
    t.integer  "p5",                 default: 0
    t.integer  "p6",                 default: 0
    t.integer  "p7",                 default: 0
    t.integer  "total_pageview",     default: 0
    t.text     "cache_hi_thumbnail"
    t.boolean  "is_list",            default: true
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "color"
    t.integer  "parent_id"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "clicks", force: true do |t|
    t.string   "ip"
    t.string   "session_id"
    t.integer  "publisher_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "clicks", ["ip", "session_id"], name: "index_clicks_on_ip_and_session_id", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "upload_image_id"
    t.string   "content"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "comments", ["upload_image_id"], name: "index_comments_on_upload_image_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "domains", force: true do |t|
    t.string "domain"
  end

  create_table "likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "upload_image_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "likes", ["upload_image_id"], name: "index_likes_on_upload_image_id", using: :btree
  add_index "likes", ["user_id", "upload_image_id"], name: "index_likes_on_user_id_and_upload_image_id", unique: true, using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "ip"
    t.string   "name"
    t.string   "email"
    t.string   "title"
    t.string   "body",       limit: 4000
    t.string   "state",                   default: "Unread"
    t.integer  "user_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "page_views", force: true do |t|
    t.string   "session_id"
    t.integer  "publisher_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.float    "number",       limit: 24, default: 0.0
    t.date     "date"
    t.float    "number_new",   limit: 24, default: 0.0
  end

  add_index "page_views", ["session_id"], name: "index_page_views_on_session_id", unique: true, using: :btree

  create_table "pages", force: true do |t|
    t.integer  "article_id"
    t.integer  "page_no"
    t.string   "title"
    t.text     "body"
    t.string   "citation"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "broken",             default: false
  end

  add_index "pages", ["article_id"], name: "index_pages_on_article_id", using: :btree
  add_index "pages", ["page_no"], name: "index_pages_on_page_no", using: :btree

  create_table "publishers", force: true do |t|
    t.string   "code"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "bank_account"
    t.string   "name"
    t.string   "paypal_email"
    t.string   "address"
    t.integer  "user_id"
    t.string   "checks_address"
    t.string   "checks_city"
    t.string   "checks_state"
    t.string   "checks_zipcode"
    t.string   "bank_bank_name"
    t.string   "bank_account_number"
    t.string   "bank_routing_number"
    t.string   "foreign_swift_code"
    t.string   "foreign_account_number"
    t.string   "foreign_irc_code"
    t.string   "foreign_iban_code"
    t.integer  "payment_method"
    t.string   "payment"
    t.string   "foreign_bank_name"
    t.string   "foreign_branch_sort_code"
    t.string   "foreign_address"
    t.string   "real_currency",            default: "Local Currency"
    t.string   "google_wallet_email"
    t.string   "foreign_currency"
  end

  add_index "publishers", ["user_id"], name: "index_publishers_on_user_id", using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "shortened_urls", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 20
    t.string   "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "shortened_urls", ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type", using: :btree
  add_index "shortened_urls", ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true, using: :btree
  add_index "shortened_urls", ["url"], name: "index_shortened_urls_on_url", using: :btree

  create_table "subscribers", force: true do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "token"
  end

  create_table "upload_images", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "image_url"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.integer  "content_file_size"
    t.datetime "content_updated_at"
    t.integer  "share_fb",             default: 0
    t.integer  "share_tw",             default: 0
    t.integer  "plus",                 default: 0
    t.integer  "impressions_count"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "user_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_admin",               default: false
    t.string   "shorten_domain"
    t.boolean  "is_writer",              default: false
    t.string   "name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visitors", force: true do |t|
    t.string   "ip"
    t.integer  "publisher_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "visitors", ["ip"], name: "index_visitors_on_ip", unique: true, using: :btree

end
