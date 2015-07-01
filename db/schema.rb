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

ActiveRecord::Schema.define(version: 20150618164341) do

  create_table "admin_logs", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.text     "action",     limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "website_id", limit: 4
  end

  add_index "admin_logs", ["user_id"], name: "index_admin_logs_on_user_id", using: :btree
  add_index "admin_logs", ["website_id"], name: "index_admin_logs_on_website_id", using: :btree

  create_table "amp_models", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.text     "description",            limit: 65535
    t.string   "amp_image_file_name",    limit: 255
    t.integer  "amp_image_file_size",    limit: 4
    t.string   "amp_image_content_type", limit: 255
    t.datetime "amp_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",            limit: 255
  end

  add_index "amp_models", ["cached_slug"], name: "index_amp_models_on_cached_slug", using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "description",  limit: 255
  end

  create_table "artist_brands", force: :cascade do |t|
    t.integer  "artist_id",  limit: 4
    t.integer  "brand_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "intro",      limit: 65535
  end

  add_index "artist_brands", ["artist_id"], name: "index_artist_brands_on_artist_id", using: :btree
  add_index "artist_brands", ["brand_id"], name: "index_artist_brands_on_brand_id", using: :btree

  create_table "artist_products", force: :cascade do |t|
    t.integer  "artist_id",  limit: 4
    t.integer  "product_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "quote",      limit: 65535
    t.boolean  "on_tour",                  default: false
    t.boolean  "favorite"
  end

  add_index "artist_products", ["artist_id", "favorite"], name: "index_artist_products_on_artist_id_and_favorite", using: :btree
  add_index "artist_products", ["artist_id"], name: "index_artist_products_on_artist_id", using: :btree
  add_index "artist_products", ["product_id", "on_tour"], name: "index_artist_products_on_product_id_and_on_tour", using: :btree
  add_index "artist_products", ["product_id"], name: "index_artist_products_on_product_id", using: :btree

  create_table "artist_tiers", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "invitation_code",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_on_artist_page"
    t.integer  "position",            limit: 4
  end

  add_index "artist_tiers", ["invitation_code"], name: "index_artist_tiers_on_invitation_code", using: :btree
  add_index "artist_tiers", ["show_on_artist_page"], name: "index_artist_tiers_on_show_on_artist_page", using: :btree

  create_table "artists", force: :cascade do |t|
    t.string   "name",                              limit: 255
    t.text     "bio",                               limit: 65535
    t.string   "artist_photo_file_name",            limit: 255
    t.string   "artist_photo_content_type",         limit: 255
    t.datetime "artist_photo_updated_at"
    t.integer  "artist_photo_file_size",            limit: 4
    t.string   "website",                           limit: 255
    t.string   "twitter",                           limit: 255
    t.integer  "position",                          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",                       limit: 255
    t.boolean  "featured",                                        default: false
    t.string   "email",                             limit: 255,   default: "",    null: false
    t.string   "encrypted_password",                limit: 128,   default: "",    null: false
    t.string   "reset_password_token",              limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     limit: 4,     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                limit: 255
    t.string   "last_sign_in_ip",                   limit: 255
    t.string   "confirmation_token",                limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "artist_product_photo_file_name",    limit: 255
    t.integer  "artist_product_photo_file_size",    limit: 4
    t.string   "artist_product_photo_content_type", limit: 255
    t.datetime "artist_product_photo_updated_at"
    t.string   "invitation_code",                   limit: 255
    t.integer  "artist_tier_id",                    limit: 4
    t.string   "main_instrument",                   limit: 255
    t.text     "notable_career_moments",            limit: 65535
    t.integer  "approver_id",                       limit: 4
  end

  add_index "artists", ["approver_id"], name: "index_artists_on_approver_id", using: :btree
  add_index "artists", ["artist_tier_id"], name: "index_artists_on_artist_tier_id", using: :btree
  add_index "artists", ["cached_slug"], name: "index_artists_on_cached_slug", unique: true, using: :btree
  add_index "artists", ["confirmation_token"], name: "index_artists_on_confirmation_token", unique: true, using: :btree
  add_index "artists", ["featured"], name: "index_artists_on_featured", using: :btree
  add_index "artists", ["reset_password_token"], name: "index_artists_on_reset_password_token", unique: true, using: :btree

  create_table "audio_demos", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.text     "description",           limit: 65535
    t.string   "wet_demo_file_name",    limit: 255
    t.integer  "wet_demo_file_size",    limit: 4
    t.string   "wet_demo_content_type", limit: 255
    t.datetime "wet_demo_updated_at"
    t.string   "dry_demo_file_name",    limit: 255
    t.integer  "dry_demo_file_size",    limit: 4
    t.string   "dry_demo_content_type", limit: 255
    t.datetime "dry_demo_updated_at"
    t.integer  "duration_in_seconds",   limit: 4
    t.integer  "brand_id",              limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "audio_demos", ["brand_id"], name: "index_audio_demos_on_brand_id", using: :btree

  create_table "blog_articles", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.integer  "blog_id",     limit: 4
    t.date     "post_on"
    t.integer  "author_id",   limit: 4
    t.text     "body",        limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "cached_slug", limit: 255
  end

  add_index "blog_articles", ["author_id"], name: "index_blog_articles_on_author_id", using: :btree
  add_index "blog_articles", ["blog_id"], name: "index_blog_articles_on_blog_id", using: :btree
  add_index "blog_articles", ["cached_slug"], name: "index_blog_articles_on_cached_slug", using: :btree

  create_table "blogs", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.integer  "brand_id",           limit: 4
    t.integer  "default_article_id", limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "cached_slug",        limit: 255
  end

  add_index "blogs", ["brand_id"], name: "index_blogs_on_brand_id", using: :btree
  add_index "blogs", ["cached_slug"], name: "index_blogs_on_cached_slug", using: :btree

  create_table "brand_dealers", force: :cascade do |t|
    t.integer  "brand_id",   limit: 4
    t.integer  "dealer_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "brand_dealers", ["brand_id"], name: "index_brand_dealers_on_brand_id", using: :btree
  add_index "brand_dealers", ["dealer_id"], name: "index_brand_dealers_on_dealer_id", using: :btree

  create_table "brand_distributors", force: :cascade do |t|
    t.integer  "distributor_id", limit: 4
    t.integer  "brand_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_distributors", ["brand_id"], name: "index_brand_distributors_on_brand_id", using: :btree
  add_index "brand_distributors", ["distributor_id"], name: "index_brand_distributors_on_distributor_id", using: :btree

  create_table "brand_toolkit_contacts", force: :cascade do |t|
    t.integer  "brand_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "position",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "brands", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",                   limit: 255
    t.integer  "default_website_id",            limit: 4
    t.boolean  "has_effects",                               default: false
    t.boolean  "has_reviews",                               default: true
    t.boolean  "has_faqs",                                  default: true
    t.boolean  "has_tone_library",                          default: false
    t.boolean  "has_artists",                               default: true
    t.boolean  "has_software",                              default: true
    t.boolean  "has_registered_downloads",                  default: false
    t.boolean  "has_online_retailers",                      default: true
    t.boolean  "has_distributors",                          default: true
    t.boolean  "has_dealers",                               default: true
    t.boolean  "has_service_centers",                       default: false
    t.string   "default_locale",                limit: 255
    t.integer  "dealers_from_brand_id",         limit: 4
    t.integer  "distributors_from_brand_id",    limit: 4
    t.string   "logo_file_name",                limit: 255
    t.string   "logo_content_type",             limit: 255
    t.datetime "logo_updated_at"
    t.integer  "logo_file_size",                limit: 4
    t.string   "news_feed_url",                 limit: 255
    t.boolean  "has_market_segments"
    t.boolean  "has_parts_form"
    t.boolean  "has_rma_form"
    t.boolean  "has_training",                              default: false
    t.integer  "service_centers_from_brand_id", limit: 4
    t.boolean  "show_pricing"
    t.boolean  "has_suggested_products"
    t.boolean  "has_blogs"
    t.boolean  "has_audio_demos",                           default: false
    t.boolean  "has_vintage_repair"
    t.boolean  "has_label_sheets"
    t.boolean  "employee_store"
    t.boolean  "live_on_this_platform"
    t.boolean  "product_trees"
    t.boolean  "has_us_sales_reps"
    t.integer  "us_sales_reps_from_brand_id",   limit: 4
    t.boolean  "queue"
    t.boolean  "toolkit"
    t.string   "color",                         limit: 255
    t.boolean  "has_products"
    t.boolean  "has_system_configurator",                   default: false
    t.boolean  "offers_rentals"
  end

  add_index "brands", ["cached_slug"], name: "index_brands_on_cached_slug", unique: true, using: :btree
  add_index "brands", ["name"], name: "index_brands_on_name", unique: true, using: :btree

  create_table "cabinets", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.text     "description",            limit: 65535
    t.string   "cab_image_file_name",    limit: 255
    t.integer  "cab_image_file_size",    limit: 4
    t.string   "cab_image_content_type", limit: 255
    t.datetime "cab_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",            limit: 255
  end

  add_index "cabinets", ["cached_slug"], name: "index_cabinets_on_cached_slug", using: :btree

  create_table "contact_messages", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.string   "email",                 limit: 255
    t.string   "subject",               limit: 255
    t.text     "message",               limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product",               limit: 255
    t.string   "operating_system",      limit: 255
    t.string   "message_type",          limit: 255
    t.string   "company",               limit: 255
    t.string   "account_number",        limit: 255
    t.string   "phone",                 limit: 255
    t.string   "fax",                   limit: 255
    t.string   "billing_address",       limit: 255
    t.string   "billing_city",          limit: 255
    t.string   "billing_state",         limit: 255
    t.string   "billing_zip",           limit: 255
    t.string   "shipping_address",      limit: 255
    t.string   "shipping_city",         limit: 255
    t.string   "shipping_state",        limit: 255
    t.string   "shipping_zip",          limit: 255
    t.string   "product_sku",           limit: 255
    t.string   "product_serial_number", limit: 255
    t.boolean  "warranty"
    t.date     "purchased_on"
    t.string   "part_number",           limit: 255
    t.string   "board_location",        limit: 255
    t.string   "shipping_country",      limit: 255
    t.integer  "brand_id",              limit: 4
  end

  add_index "contact_messages", ["brand_id"], name: "index_contact_messages_on_brand_id", using: :btree

  create_table "content_translations", force: :cascade do |t|
    t.string   "content_type",   limit: 255
    t.integer  "content_id",     limit: 4
    t.string   "content_method", limit: 255
    t.string   "locale",         limit: 255
    t.text     "content",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_translations", ["content_id"], name: "index_content_translations_on_content_id", using: :btree
  add_index "content_translations", ["content_method"], name: "index_content_translations_on_content_method", using: :btree
  add_index "content_translations", ["content_type", "content_id"], name: "index_content_translations_on_content_type_and_content_id", using: :btree
  add_index "content_translations", ["content_type"], name: "index_content_translations_on_content_type", using: :btree
  add_index "content_translations", ["locale"], name: "index_content_translations_on_locale", using: :btree

  create_table "dealer_users", force: :cascade do |t|
    t.integer  "dealer_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "dealer_users", ["dealer_id"], name: "index_dealer_users_on_dealer_id", using: :btree
  add_index "dealer_users", ["user_id"], name: "index_dealer_users_on_user_id", using: :btree

  create_table "dealers", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "name2",              limit: 255
    t.string   "name3",              limit: 255
    t.string   "name4",              limit: 255
    t.string   "address",            limit: 255
    t.string   "city",               limit: 255
    t.string   "state",              limit: 255
    t.string   "zip",                limit: 255
    t.string   "telephone",          limit: 255
    t.string   "fax",                limit: 255
    t.string   "email",              limit: 255
    t.string   "account_number",     limit: 255
    t.decimal  "lat",                            precision: 15, scale: 10
    t.decimal  "lng",                            precision: 15, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exclude"
    t.boolean  "skip_sync_from_sap"
  end

  add_index "dealers", ["account_number"], name: "index_dealers_on_account_number", using: :btree
  add_index "dealers", ["exclude"], name: "index_dealers_on_exclude", using: :btree
  add_index "dealers", ["lat", "lng"], name: "index_dealers_on_lat_and_lng", using: :btree
  add_index "dealers", ["skip_sync_from_sap"], name: "index_dealers_on_skip_sync_from_sap", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0
    t.integer  "attempts",   limit: 4,     default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue",      limit: 255
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "demo_songs", force: :cascade do |t|
    t.integer  "product_attachment_id", limit: 4
    t.integer  "position",              limit: 4
    t.string   "title",                 limit: 255
    t.string   "mp3_file_name",         limit: 255
    t.integer  "mp3_file_size",         limit: 4
    t.string   "mp3_content_type",      limit: 255
    t.datetime "mp3_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "demo_songs", ["product_attachment_id"], name: "index_demo_songs_on_product_attachment_id", using: :btree

  create_table "distributor_users", force: :cascade do |t|
    t.integer  "distributor_id", limit: 4
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "distributor_users", ["distributor_id"], name: "index_distributor_users_on_distributor_id", using: :btree
  add_index "distributor_users", ["user_id"], name: "index_distributor_users_on_user_id", using: :btree

  create_table "distributors", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.text     "detail",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country",        limit: 255
    t.string   "email",          limit: 255
    t.string   "account_number", limit: 255
  end

  add_index "distributors", ["account_number"], name: "index_distributors_on_account_number", using: :btree
  add_index "distributors", ["country"], name: "index_distributors_on_country", using: :btree
  add_index "distributors", ["email"], name: "index_distributors_on_email", using: :btree

  create_table "download_registrations", force: :cascade do |t|
    t.integer  "registered_download_id", limit: 4
    t.string   "email",                  limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "serial_number",          limit: 255
    t.integer  "download_count",         limit: 4
    t.string   "download_code",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subscribe"
    t.string   "product",                limit: 255
    t.string   "employee_number",        limit: 255
    t.string   "store_number",           limit: 255
    t.string   "manager_name",           limit: 255
    t.string   "receipt_file_name",      limit: 255
    t.integer  "receipt_file_size",      limit: 4
    t.string   "receipt_content_type",   limit: 255
    t.datetime "receipt_updated_at"
  end

  create_table "effect_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "effects", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.text     "description",               limit: 65535
    t.string   "effect_image_file_name",    limit: 255
    t.integer  "effect_image_file_size",    limit: 4
    t.string   "effect_image_content_type", limit: 255
    t.datetime "effect_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "effect_type_id",            limit: 4
    t.string   "cached_slug",               limit: 255
  end

  add_index "effects", ["cached_slug"], name: "index_effects_on_cached_slug", using: :btree
  add_index "effects", ["effect_type_id"], name: "index_effects_on_effect_type_id", using: :btree

  create_table "faq_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "brand_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faq_categories", ["brand_id"], name: "index_faq_categories_on_brand_id", using: :btree

  create_table "faq_category_faqs", force: :cascade do |t|
    t.integer  "faq_category_id", limit: 4
    t.integer  "faq_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faq_category_faqs", ["faq_category_id"], name: "index_faq_category_faqs_on_faq_category_id", using: :btree
  add_index "faq_category_faqs", ["faq_id"], name: "index_faq_category_faqs_on_faq_id", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.text     "question",   limit: 65535
    t.text     "answer",     limit: 65535
    t.boolean  "hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faqs", ["product_id"], name: "index_faqs_on_product_id", using: :btree

  create_table "forem_categories", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255
    t.integer  "sluggable_id",   limit: 4
    t.string   "sluggable_type", limit: 40
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "label_sheet_orders", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.text     "label_sheets", limit: 65535
    t.date     "mailed_on"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name",         limit: 255
    t.string   "email",        limit: 255
    t.string   "address",      limit: 255
    t.string   "city",         limit: 255
    t.string   "state",        limit: 255
    t.string   "postal_code",  limit: 255
    t.string   "country",      limit: 255
    t.boolean  "subscribe"
    t.string   "secret_code",  limit: 255
  end

  create_table "label_sheets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "products",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "locale_product_families", force: :cascade do |t|
    t.string   "locale",            limit: 255
    t.integer  "product_family_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "market_segment_product_families", force: :cascade do |t|
    t.integer  "market_segment_id", limit: 4
    t.integer  "product_family_id", limit: 4
    t.integer  "position",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "market_segments", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.integer  "brand_id",                  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",               limit: 255
    t.string   "banner_image_file_name",    limit: 255
    t.string   "banner_image_content_type", limit: 255
    t.integer  "banner_image_file_size",    limit: 4
    t.datetime "banner_image_updated_at"
    t.integer  "parent_id",                 limit: 4
    t.integer  "position",                  limit: 4
    t.text     "description",               limit: 65535
  end

  add_index "market_segments", ["cached_slug"], name: "index_market_segments_on_cached_slug", using: :btree

  create_table "marketing_attachments", force: :cascade do |t|
    t.integer  "marketing_project_id",        limit: 4
    t.string   "marketing_file_file_name",    limit: 255
    t.integer  "marketing_file_file_size",    limit: 4
    t.string   "marketing_file_content_type", limit: 255
    t.datetime "marketing_file_updated_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "marketing_task_id",           limit: 4
  end

  add_index "marketing_attachments", ["marketing_project_id"], name: "index_marketing_attachments_on_marketing_project_id", using: :btree
  add_index "marketing_attachments", ["marketing_task_id"], name: "index_marketing_attachments_on_marketing_task_id", using: :btree

  create_table "marketing_calendars", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "marketing_comments", force: :cascade do |t|
    t.integer  "marketing_project_id", limit: 4
    t.integer  "user_id",              limit: 4
    t.text     "message",              limit: 65535
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "marketing_task_id",    limit: 4
  end

  add_index "marketing_comments", ["marketing_project_id"], name: "index_marketing_comments_on_marketing_project_id", using: :btree
  add_index "marketing_comments", ["marketing_task_id"], name: "index_marketing_comments_on_marketing_task_id", using: :btree

  create_table "marketing_project_type_tasks", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.integer  "position",                  limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "marketing_project_type_id", limit: 4
    t.integer  "due_offset_number",         limit: 4
    t.string   "due_offset_unit",           limit: 255
    t.text     "creative_brief",            limit: 65535
  end

  add_index "marketing_project_type_tasks", ["marketing_project_type_id"], name: "index_marketing_project_type_tasks_on_marketing_project_type_id", using: :btree

  create_table "marketing_project_types", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.boolean  "major_effort"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "put_source_on_toolkit"
    t.boolean  "put_final_on_toolkit"
  end

  create_table "marketing_projects", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.integer  "brand_id",                  limit: 4
    t.integer  "user_id",                   limit: 4
    t.integer  "marketing_project_type_id", limit: 4
    t.date     "event_start_on"
    t.date     "event_end_on"
    t.string   "targets",                   limit: 255
    t.string   "targets_progress",          limit: 255
    t.float    "estimated_cost",            limit: 24
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "put_source_on_toolkit"
    t.boolean  "put_final_on_toolkit"
    t.date     "due_on"
    t.integer  "marketing_calendar_id",     limit: 4
  end

  add_index "marketing_projects", ["brand_id"], name: "index_marketing_projects_on_brand_id", using: :btree
  add_index "marketing_projects", ["marketing_calendar_id"], name: "index_marketing_projects_on_marketing_calendar_id", using: :btree
  add_index "marketing_projects", ["marketing_project_type_id"], name: "index_marketing_projects_on_marketing_project_type_id", using: :btree
  add_index "marketing_projects", ["user_id"], name: "index_marketing_projects_on_user_id", using: :btree

  create_table "marketing_tasks", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.integer  "marketing_project_id",  limit: 4
    t.integer  "brand_id",              limit: 4
    t.date     "due_on"
    t.integer  "requestor_id",          limit: 4
    t.integer  "worker_id",             limit: 4
    t.datetime "completed_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "position",              limit: 4
    t.float    "man_hours",             limit: 24
    t.integer  "currently_with_id",     limit: 4
    t.integer  "priority",              limit: 4
    t.text     "creative_brief",        limit: 65535
    t.integer  "marketing_calendar_id", limit: 4
  end

  add_index "marketing_tasks", ["brand_id"], name: "index_marketing_tasks_on_brand_id", using: :btree
  add_index "marketing_tasks", ["marketing_calendar_id"], name: "index_marketing_tasks_on_marketing_calendar_id", using: :btree
  add_index "marketing_tasks", ["marketing_project_id"], name: "index_marketing_tasks_on_marketing_project_id", using: :btree
  add_index "marketing_tasks", ["requestor_id"], name: "index_marketing_tasks_on_requestor_id", using: :btree
  add_index "marketing_tasks", ["worker_id"], name: "index_marketing_tasks_on_worker_id", using: :btree

  create_table "news", force: :cascade do |t|
    t.date     "post_on"
    t.string   "title",                   limit: 255
    t.text     "body",                    limit: 65535
    t.text     "keywords",                limit: 65535
    t.string   "news_photo_file_name",    limit: 255
    t.integer  "news_photo_file_size",    limit: 4
    t.datetime "news_photo_updated_at"
    t.string   "news_photo_content_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",             limit: 255
    t.integer  "brand_id",                limit: 4
    t.text     "quote",                   limit: 65535
  end

  add_index "news", ["brand_id"], name: "index_news_on_brand_id", using: :btree
  add_index "news", ["cached_slug"], name: "index_news_on_cached_slug", unique: true, using: :btree

  create_table "news_products", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "news_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_products", ["news_id"], name: "index_news_products_on_news_id", using: :btree
  add_index "news_products", ["product_id"], name: "index_news_products_on_product_id", using: :btree

  create_table "online_retailer_links", force: :cascade do |t|
    t.integer  "product_id",         limit: 4
    t.integer  "brand_id",           limit: 4
    t.integer  "online_retailer_id", limit: 4
    t.string   "url",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "link_checked_at"
    t.string   "link_status",        limit: 255, default: "200"
  end

  add_index "online_retailer_links", ["brand_id"], name: "index_online_retailer_links_on_brand_id", using: :btree
  add_index "online_retailer_links", ["online_retailer_id", "brand_id"], name: "index_online_retailer_links_on_online_retailer_id_and_brand_id", using: :btree
  add_index "online_retailer_links", ["online_retailer_id", "product_id"], name: "index_online_retailer_links_on_online_retailer_id_and_product_id", using: :btree
  add_index "online_retailer_links", ["online_retailer_id"], name: "index_online_retailer_links_on_online_retailer_id", using: :btree
  add_index "online_retailer_links", ["product_id"], name: "index_online_retailer_links_on_product_id", using: :btree

  create_table "online_retailer_users", force: :cascade do |t|
    t.integer  "online_retailer_id", limit: 4
    t.integer  "user_id",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_retailer_users", ["online_retailer_id"], name: "index_online_retailer_users_on_online_retailer_id", using: :btree
  add_index "online_retailer_users", ["user_id"], name: "index_online_retailer_users_on_user_id", using: :btree

  create_table "online_retailers", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "retailer_logo_file_name",    limit: 255
    t.integer  "retailer_logo_file_size",    limit: 4
    t.string   "retailer_logo_content_type", limit: 255
    t.datetime "retailer_logo_updated_at"
    t.boolean  "active",                                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",                limit: 255
    t.string   "direct_link",                limit: 255
    t.integer  "preferred",                  limit: 4
  end

  add_index "online_retailers", ["cached_slug"], name: "index_online_retailers_on_cached_slug", unique: true, using: :btree

  create_table "operating_systems", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "version",    limit: 255
    t.string   "arch",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.string   "keywords",     limit: 255
    t.text     "description",  limit: 65535
    t.text     "body",         limit: 65535
    t.string   "custom_route", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",  limit: 255
    t.integer  "brand_id",     limit: 4
    t.string   "password",     limit: 255
    t.string   "username",     limit: 255
    t.text     "custom_css",   limit: 65535
    t.string   "layout_class", limit: 255
  end

  add_index "pages", ["brand_id"], name: "index_pages_on_brand_id", using: :btree
  add_index "pages", ["cached_slug"], name: "index_pages_on_cached_slug", unique: true, using: :btree
  add_index "pages", ["custom_route"], name: "index_pages_on_custom_route", using: :btree

  create_table "parent_products", force: :cascade do |t|
    t.integer  "parent_product_id", limit: 4
    t.integer  "product_id",        limit: 4
    t.integer  "position",          limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "parent_products", ["parent_product_id"], name: "index_parent_products_on_parent_product_id", using: :btree
  add_index "parent_products", ["product_id"], name: "index_parent_products_on_product_id", using: :btree

  create_table "pricing_types", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.integer  "brand_id",           limit: 4
    t.integer  "pricelist_order",    limit: 4
    t.string   "calculation_method", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "us"
    t.boolean  "intl"
  end

  add_index "pricing_types", ["brand_id"], name: "index_pricing_types_on_brand_id", using: :btree

  create_table "product_amp_models", force: :cascade do |t|
    t.integer  "product_id",   limit: 4
    t.integer  "amp_model_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_amp_models", ["amp_model_id"], name: "index_product_amp_models_on_amp_model_id", using: :btree
  add_index "product_amp_models", ["product_id"], name: "index_product_amp_models_on_product_id", using: :btree

  create_table "product_attachments", force: :cascade do |t|
    t.integer  "product_id",                       limit: 4
    t.boolean  "primary_photo",                                  default: false
    t.string   "product_attachment_file_name",     limit: 255
    t.string   "product_attachment_content_type",  limit: 255
    t.datetime "product_attachment_updated_at"
    t.integer  "product_attachment_file_size",     limit: 4
    t.integer  "position",                         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product_media_file_name",          limit: 255
    t.string   "product_media_content_type",       limit: 255
    t.integer  "product_media_file_size",          limit: 4
    t.datetime "product_media_updated_at"
    t.string   "product_media_thumb_file_name",    limit: 255
    t.string   "product_media_thumb_content_type", limit: 255
    t.integer  "product_media_thumb_file_size",    limit: 4
    t.datetime "product_media_thumb_updated_at"
    t.integer  "width",                            limit: 8
    t.integer  "height",                           limit: 8
    t.string   "songlist_tag",                     limit: 255
    t.boolean  "no_lightbox"
    t.boolean  "hide_from_product_page"
    t.text     "product_attachment_meta",          limit: 65535
  end

  add_index "product_attachments", ["product_id", "primary_photo"], name: "index_product_attachments_on_product_id_and_primary_photo", using: :btree
  add_index "product_attachments", ["product_id"], name: "index_product_attachments_on_product_id", using: :btree

  create_table "product_audio_demos", force: :cascade do |t|
    t.integer  "audio_demo_id", limit: 4
    t.integer  "product_id",    limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "product_audio_demos", ["audio_demo_id"], name: "index_product_audio_demos_on_audio_demo_id", using: :btree
  add_index "product_audio_demos", ["product_id"], name: "index_product_audio_demos_on_product_id", using: :btree

  create_table "product_cabinets", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "cabinet_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_cabinets", ["cabinet_id"], name: "index_product_cabinets_on_cabinet_id", using: :btree
  add_index "product_cabinets", ["product_id"], name: "index_product_cabinets_on_product_id", using: :btree

  create_table "product_documents", force: :cascade do |t|
    t.integer  "product_id",            limit: 4
    t.string   "language",              limit: 255
    t.string   "document_type",         limit: 255
    t.string   "document_file_name",    limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.string   "document_content_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",           limit: 255
    t.string   "name_override",         limit: 255
  end

  add_index "product_documents", ["cached_slug"], name: "index_product_documents_on_cached_slug", unique: true, using: :btree
  add_index "product_documents", ["product_id"], name: "index_product_documents_on_product_id", using: :btree

  create_table "product_effects", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "effect_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_effects", ["effect_id"], name: "index_product_effects_on_effect_id", using: :btree
  add_index "product_effects", ["product_id"], name: "index_product_effects_on_product_id", using: :btree

  create_table "product_families", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.string   "family_photo_file_name",        limit: 255
    t.string   "family_photo_content_type",     limit: 255
    t.datetime "family_photo_updated_at"
    t.integer  "family_photo_file_size",        limit: 4
    t.text     "intro",                         limit: 65535
    t.integer  "brand_id",                      limit: 4
    t.text     "keywords",                      limit: 65535
    t.integer  "position",                      limit: 4
    t.integer  "parent_id",                     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hide_from_homepage",                          default: false
    t.string   "cached_slug",                   limit: 255
    t.string   "background_image_file_name",    limit: 255
    t.integer  "background_image_file_size",    limit: 4
    t.string   "background_image_content_type", limit: 255
    t.datetime "background_image_updated_at"
    t.string   "background_color",              limit: 255
    t.string   "layout_class",                  limit: 255
    t.string   "family_banner_file_name",       limit: 255
    t.string   "family_banner_content_type",    limit: 255
    t.integer  "family_banner_file_size",       limit: 4
    t.datetime "family_banner_updated_at"
    t.string   "title_banner_file_name",        limit: 255
    t.string   "title_banner_content_type",     limit: 255
    t.integer  "title_banner_file_size",        limit: 4
    t.datetime "title_banner_updated_at"
  end

  add_index "product_families", ["brand_id"], name: "index_product_families_on_brand_id", using: :btree
  add_index "product_families", ["cached_slug"], name: "index_product_families_on_cached_slug", unique: true, using: :btree
  add_index "product_families", ["parent_id"], name: "index_product_families_on_parent_id", using: :btree

  create_table "product_family_products", force: :cascade do |t|
    t.integer  "product_id",        limit: 4
    t.integer  "product_family_id", limit: 4
    t.integer  "position",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_family_products", ["product_family_id"], name: "index_product_family_products_on_product_family_id", using: :btree
  add_index "product_family_products", ["product_id"], name: "index_product_family_products_on_product_id", using: :btree

  create_table "product_introductions", force: :cascade do |t|
    t.integer  "product_id",                 limit: 4
    t.string   "layout_class",               limit: 255
    t.date     "expires_on"
    t.text     "content",                    limit: 65535
    t.text     "extra_css",                  limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "top_image_file_name",        limit: 255
    t.integer  "top_image_file_size",        limit: 4
    t.string   "top_image_content_type",     limit: 255
    t.datetime "top_image_updated_at"
    t.string   "box_bg_image_file_name",     limit: 255
    t.integer  "box_bg_image_file_size",     limit: 4
    t.string   "box_bg_image_content_type",  limit: 255
    t.datetime "box_bg_image_updated_at"
    t.string   "page_bg_image_file_name",    limit: 255
    t.integer  "page_bg_image_file_size",    limit: 4
    t.string   "page_bg_image_content_type", limit: 255
    t.datetime "page_bg_image_updated_at"
  end

  add_index "product_introductions", ["product_id"], name: "index_product_introductions_on_product_id", using: :btree

  create_table "product_prices", force: :cascade do |t|
    t.integer  "product_id",      limit: 4
    t.integer  "pricing_type_id", limit: 4
    t.integer  "price_cents",     limit: 4,   default: 0,     null: false
    t.string   "price_currency",  limit: 255, default: "USD", null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "product_prices", ["pricing_type_id"], name: "index_product_prices_on_pricing_type_id", using: :btree
  add_index "product_prices", ["product_id"], name: "index_product_prices_on_product_id", using: :btree

  create_table "product_promotions", force: :cascade do |t|
    t.integer  "product_id",   limit: 4
    t.integer  "promotion_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_promotions", ["product_id"], name: "index_product_promotions_on_product_id", using: :btree
  add_index "product_promotions", ["promotion_id"], name: "index_product_promotions_on_promotion_id", using: :btree

  create_table "product_review_products", force: :cascade do |t|
    t.integer  "product_id",        limit: 4
    t.integer  "product_review_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_review_products", ["product_id"], name: "index_product_review_products_on_product_id", using: :btree
  add_index "product_review_products", ["product_review_id"], name: "index_product_review_products_on_product_review_id", using: :btree

  create_table "product_reviews", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.string   "external_link",            limit: 255
    t.text     "body",                     limit: 65535
    t.string   "review_file_name",         limit: 255
    t.integer  "review_file_size",         limit: 4
    t.string   "review_content_type",      limit: 255
    t.datetime "review_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",              limit: 255
    t.datetime "link_checked_at"
    t.string   "link_status",              limit: 255,   default: "200"
    t.string   "cover_image_file_name",    limit: 255
    t.string   "cover_image_content_type", limit: 255
    t.integer  "cover_image_file_size",    limit: 4
    t.datetime "cover_image_updated_at"
  end

  add_index "product_reviews", ["cached_slug"], name: "index_product_reviews_on_cached_slug", unique: true, using: :btree

  create_table "product_site_elements", force: :cascade do |t|
    t.integer  "product_id",      limit: 4
    t.integer  "site_element_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "product_site_elements", ["product_id"], name: "index_product_site_elements_on_product_id", using: :btree
  add_index "product_site_elements", ["site_element_id"], name: "index_product_site_elements_on_site_element_id", using: :btree

  create_table "product_softwares", force: :cascade do |t|
    t.integer  "product_id",        limit: 4
    t.integer  "software_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_position",  limit: 4
    t.integer  "software_position", limit: 4
  end

  add_index "product_softwares", ["product_id"], name: "index_product_softwares_on_product_id", using: :btree
  add_index "product_softwares", ["software_id"], name: "index_product_softwares_on_software_id", using: :btree

  create_table "product_specifications", force: :cascade do |t|
    t.integer  "product_id",       limit: 4
    t.integer  "specification_id", limit: 4
    t.string   "value",            limit: 255
    t.integer  "position",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_specifications", ["product_id"], name: "index_product_specifications_on_product_id", using: :btree
  add_index "product_specifications", ["specification_id"], name: "index_product_specifications_on_specification_id", using: :btree

  create_table "product_statuses", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.boolean  "show_on_website",             default: false
    t.boolean  "discontinued",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shipping",                    default: false
  end

  create_table "product_suggestions", force: :cascade do |t|
    t.integer  "product_id",           limit: 4
    t.integer  "suggested_product_id", limit: 4
    t.integer  "position",             limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "product_training_classes", force: :cascade do |t|
    t.integer  "product_id",        limit: 4
    t.integer  "training_class_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_training_modules", force: :cascade do |t|
    t.integer  "product_id",         limit: 4
    t.integer  "training_module_id", limit: 4
    t.integer  "position",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",                           limit: 255
    t.string   "sap_sku",                        limit: 255
    t.text     "description",                    limit: 65535
    t.text     "short_description",              limit: 65535
    t.text     "keywords",                       limit: 65535
    t.integer  "product_status_id",              limit: 4
    t.boolean  "rohs",                                         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "extended_description",           limit: 65535
    t.string   "cached_slug",                    limit: 255
    t.string   "background_image_file_name",     limit: 255
    t.integer  "background_image_file_size",     limit: 4
    t.string   "background_image_content_type",  limit: 255
    t.datetime "background_image_updated_at"
    t.string   "background_color",               limit: 255
    t.text     "features",                       limit: 65535
    t.string   "password",                       limit: 255
    t.text     "previewers",                     limit: 65535
    t.boolean  "has_pedals",                                   default: false
    t.integer  "brand_id",                       limit: 4
    t.integer  "warranty_period",                limit: 4
    t.string   "layout_class",                   limit: 255
    t.string   "direct_buy_link",                limit: 255
    t.string   "features_tab_name",              limit: 255
    t.string   "demo_link",                      limit: 255
    t.boolean  "hide_buy_it_now_button"
    t.string   "more_info_url",                  limit: 255
    t.integer  "parent_products_count",          limit: 4,     default: 0,     null: false
    t.string   "short_description_1",            limit: 255
    t.string   "short_description_2",            limit: 255
    t.string   "short_description_3",            limit: 255
    t.string   "short_description_4",            limit: 255
    t.string   "stock_status",                   limit: 255
    t.date     "available_on"
    t.integer  "stock_level",                    limit: 4
    t.integer  "harman_employee_price_cents",    limit: 4
    t.string   "harman_employee_price_currency", limit: 255,   default: "USD", null: false
    t.integer  "street_price_cents",             limit: 4
    t.string   "street_price_currency",          limit: 255,   default: "USD", null: false
    t.integer  "msrp_cents",                     limit: 4
    t.string   "msrp_currency",                  limit: 255,   default: "USD", null: false
    t.integer  "sale_price_cents",               limit: 4
    t.string   "sale_price_currency",            limit: 255,   default: "USD", null: false
    t.integer  "cost_cents",                     limit: 4
    t.string   "cost_currency",                  limit: 255,   default: "USD", null: false
    t.text     "alert",                          limit: 65535
    t.boolean  "show_alert",                                   default: false
    t.string   "extended_description_tab_name",  limit: 255
    t.string   "product_page_url",               limit: 255
  end

  add_index "products", ["brand_id", "product_status_id"], name: "index_products_on_brand_id_and_product_status_id", using: :btree
  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree
  add_index "products", ["cached_slug"], name: "index_products_on_cached_slug", unique: true, using: :btree

  create_table "promotions", force: :cascade do |t|
    t.string   "name",                           limit: 255
    t.date     "show_start_on"
    t.date     "show_end_on"
    t.date     "start_on"
    t.date     "end_on"
    t.text     "description",                    limit: 65535
    t.string   "promo_form_file_name",           limit: 255
    t.integer  "promo_form_file_size",           limit: 4
    t.datetime "promo_form_updated_at"
    t.string   "promo_form_content_type",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",                    limit: 255
    t.string   "tile_file_name",                 limit: 255
    t.integer  "tile_file_size",                 limit: 4
    t.string   "tile_content_type",              limit: 255
    t.datetime "tile_updated_at"
    t.string   "post_registration_subject",      limit: 255
    t.text     "post_registration_message",      limit: 65535
    t.boolean  "send_post_registration_message",               default: false
    t.integer  "brand_id",                       limit: 4
    t.text     "toolkit_instructions",           limit: 65535
    t.string   "homepage_banner_file_name",      limit: 255
    t.string   "homepage_banner_content_type",   limit: 255
    t.integer  "homepage_banner_file_size",      limit: 4
    t.datetime "homepage_banner_updated_at"
    t.string   "homepage_headline",              limit: 255
    t.text     "homepage_text",                  limit: 65535
    t.float    "discount",                       limit: 24
    t.string   "discount_type",                  limit: 255
    t.boolean  "show_recalculated_price"
  end

  add_index "promotions", ["cached_slug"], name: "index_promotions_on_cached_slug", unique: true, using: :btree

  create_table "registered_downloads", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.integer  "brand_id",                        limit: 4
    t.string   "protected_software_file_name",    limit: 255
    t.integer  "protected_software_file_size",    limit: 4
    t.string   "protected_software_content_type", limit: 255
    t.datetime "protected_software_updated_at"
    t.integer  "download_count",                  limit: 4
    t.text     "html_template",                   limit: 65535
    t.text     "intro_page_content",              limit: 65535
    t.text     "confirmation_page_content",       limit: 65535
    t.text     "email_template",                  limit: 65535
    t.text     "download_page_content",           limit: 65535
    t.string   "url",                             limit: 255
    t.string   "valid_code",                      limit: 255
    t.integer  "per_download_limit",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from_email",                      limit: 255
    t.string   "subject",                         limit: 255
    t.boolean  "require_serial_number"
    t.string   "cc",                              limit: 255
    t.text     "products",                        limit: 65535
    t.boolean  "require_employee_number"
    t.boolean  "require_store_number"
    t.boolean  "require_manager_name"
    t.boolean  "send_coupon_code"
    t.text     "coupon_codes",                    limit: 65535
    t.boolean  "require_receipt"
  end

  create_table "service_centers", force: :cascade do |t|
    t.string   "name",           limit: 100
    t.string   "name2",          limit: 100
    t.string   "name3",          limit: 100
    t.string   "name4",          limit: 100
    t.string   "address",        limit: 100
    t.string   "city",           limit: 100
    t.string   "state",          limit: 50
    t.string   "zip",            limit: 40
    t.string   "telephone",      limit: 40
    t.string   "fax",            limit: 40
    t.string   "email",          limit: 100
    t.string   "account_number", limit: 50
    t.string   "website",        limit: 100
    t.decimal  "lat",                        precision: 15, scale: 10
    t.decimal  "lng",                        precision: 15, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id",       limit: 4
    t.boolean  "vintage"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "setting_type",       limit: 255
    t.string   "string_value",       limit: 255
    t.integer  "integer_value",      limit: 4
    t.text     "text_value",         limit: 65535
    t.string   "slide_file_name",    limit: 255
    t.integer  "slide_file_size",    limit: 4
    t.string   "locale",             limit: 255
    t.integer  "brand_id",           limit: 4
    t.string   "slide_content_type", limit: 255
    t.datetime "slide_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_on"
    t.date     "remove_on"
  end

  add_index "settings", ["brand_id", "name", "locale"], name: "index_settings_on_brand_id_and_name_and_locale", using: :btree
  add_index "settings", ["brand_id", "name"], name: "index_settings_on_brand_id_and_name", using: :btree
  add_index "settings", ["brand_id"], name: "index_settings_on_brand_id", using: :btree

  create_table "signups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "campaign",   limit: 255
    t.integer  "brand_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.date     "synced_on"
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "company",    limit: 255
    t.string   "address",    limit: 255
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.string   "zip",        limit: 255
  end

  create_table "site_elements", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.integer  "brand_id",                limit: 4
    t.string   "resource_file_name",      limit: 255
    t.integer  "resource_file_size",      limit: 4
    t.string   "resource_content_type",   limit: 255
    t.datetime "resource_updated_at"
    t.string   "resource_type",           limit: 255
    t.boolean  "show_on_public_site"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "executable_file_name",    limit: 255
    t.string   "executable_content_type", limit: 255
    t.integer  "executable_file_size",    limit: 4
    t.datetime "executable_updated_at"
  end

  create_table "software_activations", force: :cascade do |t|
    t.integer  "software_id",    limit: 4
    t.string   "challenge",      limit: 255
    t.string   "activation_key", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "software_attachments", force: :cascade do |t|
    t.integer  "software_id",                      limit: 4
    t.string   "software_attachment_file_name",    limit: 255
    t.integer  "software_attachment_file_size",    limit: 4
    t.string   "software_attachment_content_type", limit: 255
    t.datetime "software_attachment_updated_at"
    t.string   "name",                             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "software_operating_systems", force: :cascade do |t|
    t.integer  "software_id",         limit: 4
    t.integer  "operating_system_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "software_operating_systems", ["operating_system_id"], name: "index_software_operating_systems_on_operating_system_id", using: :btree
  add_index "software_operating_systems", ["software_id"], name: "index_software_operating_systems_on_software_id", using: :btree

  create_table "software_training_classes", force: :cascade do |t|
    t.integer  "software_id",       limit: 4
    t.integer  "training_class_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "software_training_modules", force: :cascade do |t|
    t.integer  "software_id",        limit: 4
    t.integer  "training_module_id", limit: 4
    t.integer  "position",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "softwares", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.string   "ware_file_name",          limit: 255
    t.integer  "ware_file_size",          limit: 4
    t.string   "ware_content_type",       limit: 255
    t.datetime "ware_updated_at"
    t.integer  "download_count",          limit: 4
    t.string   "version",                 limit: 255
    t.text     "description",             limit: 65535
    t.string   "platform",                limit: 255
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",                limit: 255
    t.string   "cached_slug",             limit: 255
    t.integer  "brand_id",                limit: 4
    t.string   "link",                    limit: 255
    t.text     "multipliers",             limit: 65535
    t.string   "activation_name",         limit: 255
    t.datetime "link_checked_at"
    t.string   "link_status",             limit: 255,   default: "200"
    t.string   "layout_class",            limit: 255
    t.integer  "current_version_id",      limit: 4
    t.string   "bit",                     limit: 255
    t.boolean  "active_without_products"
    t.string   "direct_upload_url",       limit: 255
    t.boolean  "processed",                             default: false
    t.text     "alert",                   limit: 65535
    t.boolean  "show_alert",                            default: false
  end

  add_index "softwares", ["cached_slug"], name: "index_softwares_on_cached_slug", unique: true, using: :btree

  create_table "specifications", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug", limit: 255
  end

  add_index "specifications", ["cached_slug"], name: "index_specifications_on_cached_slug", unique: true, using: :btree

  create_table "support_subjects", force: :cascade do |t|
    t.integer  "brand_id",   limit: 4
    t.string   "name",       limit: 255
    t.string   "recipient",  limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale",     limit: 255
  end

  add_index "support_subjects", ["brand_id"], name: "index_support_subjects_on_brand_id", using: :btree
  add_index "support_subjects", ["locale"], name: "index_support_subjects_on_locale", using: :btree

  create_table "system_components", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "system_id",   limit: 4
    t.integer  "product_id",  limit: 4
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_components", ["system_id"], name: "index_system_components_on_system_id", using: :btree

  create_table "system_configuration_components", force: :cascade do |t|
    t.integer  "system_configuration_id", limit: 4
    t.integer  "system_component_id",     limit: 4
    t.integer  "quantity",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_configuration_components", ["system_configuration_id"], name: "index_system_configuration_components_on_system_configuration_id", using: :btree

  create_table "system_configuration_option_values", force: :cascade do |t|
    t.integer  "system_configuration_option_id", limit: 4
    t.integer  "system_option_value_id",         limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "system_configuration_option_values", ["system_configuration_option_id"], name: "s_c_o_v_s_c_o_id", using: :btree

  create_table "system_configuration_options", force: :cascade do |t|
    t.integer  "system_configuration_id", limit: 4
    t.integer  "system_option_id",        limit: 4
    t.integer  "system_option_value_id",  limit: 4
    t.string   "direct_value",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_configuration_options", ["system_configuration_id"], name: "index_system_configuration_options_on_system_configuration_id", using: :btree

  create_table "system_configurations", force: :cascade do |t|
    t.integer  "system_id",                limit: 4
    t.string   "name",                     limit: 255
    t.integer  "user_id",                  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project_name",             limit: 255
    t.string   "email",                    limit: 255
    t.string   "phone",                    limit: 255
    t.string   "company",                  limit: 255
    t.string   "preferred_contact_method", limit: 255
    t.string   "access_hash",              limit: 255
  end

  create_table "system_option_values", force: :cascade do |t|
    t.integer  "system_option_id", limit: 4
    t.string   "name",             limit: 255
    t.integer  "position",         limit: 4
    t.text     "description",      limit: 65535
    t.boolean  "default",                        default: false
    t.integer  "price_cents",      limit: 4,     default: 0,     null: false
    t.string   "price_currency",   limit: 255,   default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "send_mail_to",     limit: 255
  end

  add_index "system_option_values", ["system_option_id"], name: "index_system_option_values_on_system_option_id", using: :btree

  create_table "system_options", force: :cascade do |t|
    t.integer  "system_id",            limit: 4
    t.string   "name",                 limit: 255
    t.string   "option_type",          limit: 255
    t.integer  "position",             limit: 4
    t.integer  "parent_id",            limit: 4
    t.text     "description",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "long_description",     limit: 65535
    t.string   "default_value",        limit: 255
    t.boolean  "show_on_first_screen",               default: false
  end

  add_index "system_options", ["parent_id"], name: "index_system_options_on_parent_id", using: :btree
  add_index "system_options", ["system_id"], name: "index_system_options_on_system_id", using: :btree

  create_table "system_rule_actions", force: :cascade do |t|
    t.integer  "system_rule_id",         limit: 4
    t.string   "action_type",            limit: 255
    t.integer  "system_option_id",       limit: 4
    t.integer  "system_option_value_id", limit: 4
    t.text     "alert",                  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "system_component_id",    limit: 4
    t.integer  "quantity",               limit: 4
    t.string   "ratio",                  limit: 255
  end

  add_index "system_rule_actions", ["system_rule_id"], name: "index_system_rule_actions_on_system_rule_id", using: :btree

  create_table "system_rule_condition_groups", force: :cascade do |t|
    t.integer  "system_rule_id", limit: 4
    t.string   "logic_type",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_rule_condition_groups", ["system_rule_id"], name: "index_system_rule_condition_groups_on_system_rule_id", using: :btree

  create_table "system_rule_conditions", force: :cascade do |t|
    t.integer  "system_rule_condition_group_id", limit: 4
    t.integer  "system_option_id",               limit: 4
    t.string   "operator",                       limit: 255
    t.integer  "system_option_value_id",         limit: 4
    t.string   "direct_value",                   limit: 255
    t.string   "logic_type",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_rule_conditions", ["system_rule_condition_group_id"], name: "index_system_rule_conditions_on_system_rule_condition_group_id", using: :btree

  create_table "system_rules", force: :cascade do |t|
    t.integer  "system_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",                    default: true
    t.boolean  "perform_opposite",           default: true
  end

  add_index "system_rules", ["system_id"], name: "index_system_rules_on_system_id", using: :btree

  create_table "systems", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "brand_id",         limit: 4
    t.text     "description",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "send_mail_to",     limit: 255
    t.text     "contact_me_intro", limit: 65535
  end

  add_index "systems", ["brand_id"], name: "index_systems_on_brand_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "tone_library_patches", force: :cascade do |t|
    t.integer  "tone_library_song_id", limit: 4
    t.integer  "product_id",           limit: 4
    t.string   "patch_file_name",      limit: 255
    t.integer  "patch_file_size",      limit: 4
    t.datetime "patch_updated_at"
    t.string   "patch_content_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tone_library_songs", force: :cascade do |t|
    t.string   "artist_name", limit: 255
    t.string   "title",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug", limit: 255
  end

  add_index "tone_library_songs", ["cached_slug"], name: "index_tone_library_songs_on_cached_slug", using: :btree

  create_table "toolkit_resource_types", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.integer  "position",          limit: 4
    t.string   "related_model",     limit: 255
    t.string   "related_attribute", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "marketing_message"
    t.string   "cached_slug",       limit: 255
  end

  add_index "toolkit_resource_types", ["cached_slug"], name: "index_toolkit_resource_types_on_cached_slug", using: :btree

  create_table "toolkit_resources", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.integer  "toolkit_resource_type_id", limit: 4
    t.integer  "related_id",               limit: 4
    t.string   "tk_preview_file_name",     limit: 255
    t.string   "tk_preview_content_type",  limit: 255
    t.integer  "tk_preview_file_size",     limit: 4
    t.datetime "tk_preview_updated_at"
    t.string   "download_path",            limit: 255
    t.integer  "download_file_size",       limit: 4
    t.integer  "brand_id",                 limit: 4
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "slug",                     limit: 255
    t.boolean  "dealer",                                 default: true
    t.boolean  "distributor",                            default: true
    t.boolean  "rep",                                    default: true
    t.boolean  "rso",                                    default: true
    t.text     "message",                  limit: 65535
    t.date     "expires_on"
    t.boolean  "media",                                  default: true
    t.boolean  "link_good"
    t.datetime "link_checked_at"
  end

  add_index "toolkit_resources", ["brand_id"], name: "index_toolkit_resources_on_brand_id", using: :btree
  add_index "toolkit_resources", ["related_id"], name: "index_toolkit_resources_on_related_id", using: :btree
  add_index "toolkit_resources", ["slug"], name: "index_toolkit_resources_on_slug", using: :btree

  create_table "training_classes", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.integer  "brand_id",                limit: 4
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "language",                limit: 255
    t.integer  "instructor_id",           limit: 4
    t.string   "more_info_url",           limit: 255
    t.string   "location",                limit: 255
    t.boolean  "filled"
    t.string   "class_info_file_name",    limit: 255
    t.integer  "class_info_file_size",    limit: 4
    t.string   "class_info_content_type", limit: 255
    t.datetime "class_info_updated_at"
    t.boolean  "canceled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "training_modules", force: :cascade do |t|
    t.string   "name",                         limit: 255
    t.integer  "brand_id",                     limit: 4
    t.string   "training_module_file_name",    limit: 255
    t.string   "training_module_content_type", limit: 255
    t.integer  "training_module_file_size",    limit: 4
    t.datetime "training_module_updated_at"
    t.text     "description",                  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "width",                        limit: 4
    t.integer  "height",                       limit: 4
  end

  create_table "tweets", force: :cascade do |t|
    t.integer  "brand_id",          limit: 4
    t.string   "tweet_id",          limit: 255
    t.string   "screen_name",       limit: 255
    t.text     "content",           limit: 65535
    t.string   "profile_image_url", limit: 255
    t.datetime "posted_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "tweets", ["brand_id"], name: "index_tweets_on_brand_id", using: :btree
  add_index "tweets", ["tweet_id"], name: "index_tweets_on_tweet_id", using: :btree
  add_index "tweets", ["tweet_id"], name: "tweet_id", unique: true, using: :btree

  create_table "us_regions", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "cached_slug", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "us_regions", ["cached_slug"], name: "index_us_regions_on_cached_slug", using: :btree

  create_table "us_rep_regions", force: :cascade do |t|
    t.integer  "us_rep_id",    limit: 4
    t.integer  "us_region_id", limit: 4
    t.integer  "brand_id",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "us_reps", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "contact",     limit: 255
    t.string   "address",     limit: 255
    t.string   "city",        limit: 255
    t.string   "state",       limit: 255
    t.string   "zip",         limit: 255
    t.string   "phone",       limit: 255
    t.string   "fax",         limit: 255
    t.string   "email",       limit: 255
    t.string   "cached_slug", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "us_reps", ["cached_slug"], name: "index_us_reps_on_cached_slug", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                      limit: 255, default: "", null: false
    t.string   "encrypted_password",         limit: 128, default: "", null: false
    t.string   "reset_password_token",       limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",         limit: 255
    t.string   "last_sign_in_ip",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.boolean  "customer_service"
    t.boolean  "online_retailer"
    t.boolean  "translator"
    t.boolean  "rohs"
    t.boolean  "market_manager"
    t.boolean  "artist_relations"
    t.boolean  "engineer"
    t.boolean  "clinician"
    t.boolean  "rep"
    t.string   "name",                       limit: 255
    t.boolean  "rso"
    t.boolean  "sales_admin"
    t.boolean  "dealer"
    t.boolean  "distributor"
    t.boolean  "marketing_staff"
    t.string   "phone_number",               limit: 255
    t.string   "job_description",            limit: 255
    t.string   "job_title",                  limit: 255
    t.string   "profile_image_file_name",    limit: 255
    t.string   "profile_image_content_type", limit: 255
    t.integer  "profile_image_file_size",    limit: 4
    t.datetime "profile_image_updated_at"
    t.string   "confirmation_token",         limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",          limit: 255
    t.boolean  "employee"
    t.boolean  "media"
    t.boolean  "queue_admin"
    t.string   "profile_pic_file_name",      limit: 255
    t.integer  "profile_pic_file_size",      limit: 4
    t.string   "profile_pic_content_type",   limit: 255
    t.datetime "profile_pic_updated_at"
    t.boolean  "project_manager"
    t.boolean  "executive"
    t.string   "account_number",             limit: 255
  end

  add_index "users", ["account_number"], name: "index_users_on_account_number", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "warranty_registrations", force: :cascade do |t|
    t.string   "title",               limit: 10
    t.string   "first_name",          limit: 100
    t.string   "last_name",           limit: 100
    t.string   "middle_initial",      limit: 4
    t.string   "company",             limit: 100
    t.string   "jobtitle",            limit: 100
    t.string   "address1",            limit: 255
    t.string   "city",                limit: 100
    t.string   "state",               limit: 100
    t.string   "zip",                 limit: 100
    t.string   "country",             limit: 100
    t.string   "phone",               limit: 50
    t.string   "fax",                 limit: 50
    t.string   "email",               limit: 100
    t.boolean  "subscribe"
    t.integer  "brand_id",            limit: 4
    t.integer  "product_id",          limit: 4
    t.string   "serial_number",       limit: 100
    t.date     "registered_on"
    t.date     "purchased_on"
    t.string   "purchased_from",      limit: 100
    t.string   "purchase_country",    limit: 100
    t.string   "purchase_price",      limit: 100
    t.string   "age",                 limit: 40
    t.string   "marketing_question1", limit: 100
    t.string   "marketing_question2", limit: 100
    t.string   "marketing_question3", limit: 100
    t.string   "marketing_question4", limit: 100
    t.string   "marketing_question5", limit: 100
    t.string   "marketing_question6", limit: 100
    t.string   "marketing_question7", limit: 100
    t.text     "comments",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exported",                          default: false
    t.datetime "synced_on"
  end

  add_index "warranty_registrations", ["exported"], name: "index_warranty_registrations_on_exported", using: :btree

  create_table "website_locales", force: :cascade do |t|
    t.integer  "website_id", limit: 4
    t.string   "locale",     limit: 255
    t.string   "name",       limit: 255
    t.boolean  "complete",               default: false
    t.boolean  "default",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "website_locales", ["locale", "website_id"], name: "index_website_locales_on_locale_and_website_id", using: :btree

  create_table "websites", force: :cascade do |t|
    t.string   "url",            limit: 255
    t.integer  "brand_id",       limit: 4
    t.string   "folder",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment",        limit: 255
    t.string   "default_locale", limit: 255
  end

  add_index "websites", ["brand_id"], name: "index_websites_on_brand_id", using: :btree
  add_index "websites", ["url"], name: "index_websites_on_url", unique: true, using: :btree

end
