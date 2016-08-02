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

ActiveRecord::Schema.define(version: 20160802190741) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,   null: false
    t.string   "user_type",     limit: 255
    t.string   "document_id",   limit: 255
    t.string   "title",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "document_type", limit: 255
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.string   "repository",     limit: 255
    t.string   "owner",          limit: 255
    t.string   "collection",     limit: 255
    t.string   "geo_location",   limit: 255
    t.string   "call_number",    limit: 255
    t.string   "catalog_url",    limit: 255
    t.string   "vol_number",     limit: 255
    t.string   "author",         limit: 255
    t.string   "title",          limit: 255
    t.string   "creation_place", limit: 255
    t.integer  "creation_date",  limit: 4
    t.string   "publisher",      limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "other_id",       limit: 255
    t.string   "other_id_type",  limit: 255
    t.boolean  "sammelband"
    t.integer  "created_by_id",  limit: 4
    t.integer  "updated_by_id",  limit: 4
    t.string   "date_narrative", limit: 255
  end

  create_table "content_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "context_images", force: :cascade do |t|
    t.integer  "book_id",              limit: 4
    t.integer  "photo_id",             limit: 4
    t.boolean  "publishing_to_flickr"
    t.boolean  "deleted"
    t.integer  "created_by_id",        limit: 4
    t.integer  "updated_by_id",        limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "context_images", ["book_id"], name: "index_context_images_on_book_id", using: :btree
  add_index "context_images", ["photo_id"], name: "index_context_images_on_photo_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "evidence", force: :cascade do |t|
    t.integer  "book_id",               limit: 4
    t.string   "format",                limit: 255
    t.string   "location_in_book",      limit: 255
    t.string   "location_in_book_page", limit: 255
    t.text     "transcription",         limit: 65535
    t.integer  "year_when",             limit: 4
    t.integer  "year_start",            limit: 4
    t.integer  "year_end",              limit: 4
    t.string   "date_narrative",        limit: 255
    t.string   "where",                 limit: 255
    t.text     "comments",              limit: 65535
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "photo_id",              limit: 4
    t.string   "format_other",          limit: 255
    t.boolean  "publishing_to_flickr"
    t.text     "citations",             limit: 65535
    t.boolean  "deleted",                             default: false
    t.integer  "created_by_id",         limit: 4
    t.integer  "updated_by_id",         limit: 4
  end

  add_index "evidence", ["book_id"], name: "index_evidence_on_book_id", using: :btree
  add_index "evidence", ["photo_id"], name: "index_evidence_on_photo_id", using: :btree

  create_table "evidence_content_types", force: :cascade do |t|
    t.integer  "evidence_id",     limit: 4
    t.integer  "content_type_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "evidence_content_types", ["content_type_id"], name: "index_evidence_content_types_on_content_type_id", using: :btree
  add_index "evidence_content_types", ["evidence_id"], name: "index_evidence_content_types_on_evidence_id", using: :btree

  create_table "names", force: :cascade do |t|
    t.string   "name",                    limit: 255,             null: false
    t.integer  "year_start",              limit: 4
    t.integer  "year_end",                limit: 4
    t.string   "viaf_id",                 limit: 255
    t.string   "comment",                 limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "provenance_agents_count", limit: 4,   default: 0
    t.integer  "created_by_id",           limit: 4
    t.integer  "updated_by_id",           limit: 4
  end

  add_index "names", ["name"], name: "index_names_on_name", unique: true, using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.integer  "book_id",            limit: 4
    t.boolean  "image_processing"
    t.boolean  "in_queue",                       default: true
  end

  create_table "provenance_agents", force: :cascade do |t|
    t.string   "role",        limit: 255
    t.integer  "evidence_id", limit: 4,   null: false
    t.integer  "name_id",     limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "provenance_agents", ["evidence_id"], name: "index_provenance_agents_on_evidence_id", using: :btree
  add_index "provenance_agents", ["name_id"], name: "index_provenance_agents_on_name_id", using: :btree

  create_table "publication_data", force: :cascade do |t|
    t.string   "flickr_id",        limit: 255
    t.text     "metadata",         limit: 65535
    t.integer  "publishable_id",   limit: 4
    t.string   "publishable_type", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "searches", force: :cascade do |t|
    t.text     "query_params", limit: 65535
    t.integer  "user_id",      limit: 4
    t.string   "user_type",    limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "test_table", primary_key: "field_binary", force: :cascade do |t|
  end

  create_table "title_pages", force: :cascade do |t|
    t.integer  "book_id",              limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "photo_id",             limit: 4
    t.boolean  "publishing_to_flickr"
    t.boolean  "deleted",                        default: false
    t.integer  "created_by_id",        limit: 4
    t.integer  "updated_by_id",        limit: 4
  end

  add_index "title_pages", ["book_id"], name: "index_title_pages_on_book_id", using: :btree
  add_index "title_pages", ["photo_id"], name: "index_title_pages_on_photo_id", using: :btree

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
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255
    t.datetime "deleted_at"
    t.boolean  "admin"
    t.string   "full_name",              limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "context_images", "books"
  add_foreign_key "context_images", "photos"
  add_foreign_key "evidence", "books"
  add_foreign_key "evidence", "photos"
  add_foreign_key "evidence_content_types", "content_types"
  add_foreign_key "evidence_content_types", "evidence"
  add_foreign_key "provenance_agents", "evidence"
  add_foreign_key "provenance_agents", "names"
  add_foreign_key "title_pages", "books"
  add_foreign_key "title_pages", "photos"
end
