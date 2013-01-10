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

ActiveRecord::Schema.define(:version => 20130110175143) do

  create_table "admin_logs", :force => true do |t|
    t.integer  "user_id"
    t.text     "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "website_id"
  end

  add_index "admin_logs", ["user_id"], :name => "index_admin_logs_on_user_id"
  add_index "admin_logs", ["website_id"], :name => "index_admin_logs_on_website_id"

  create_table "amp_models", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "amp_image_file_name"
    t.integer  "amp_image_file_size"
    t.string   "amp_image_content_type"
    t.datetime "amp_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "artist_brands", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "intro"
  end

  add_index "artist_brands", ["artist_id"], :name => "index_artist_brands_on_artist_id"
  add_index "artist_brands", ["brand_id"], :name => "index_artist_brands_on_brand_id"

  create_table "artist_products", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "quote"
    t.boolean  "on_tour",    :default => false
    t.boolean  "favorite"
  end

  add_index "artist_products", ["artist_id", "favorite"], :name => "index_artist_products_on_artist_id_and_favorite"
  add_index "artist_products", ["artist_id"], :name => "index_artist_products_on_artist_id"
  add_index "artist_products", ["product_id", "on_tour"], :name => "index_artist_products_on_product_id_and_on_tour"
  add_index "artist_products", ["product_id"], :name => "index_artist_products_on_product_id"

  create_table "artist_tiers", :force => true do |t|
    t.string   "name"
    t.string   "invitation_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_on_artist_page"
    t.integer  "position"
  end

  add_index "artist_tiers", ["invitation_code"], :name => "index_artist_tiers_on_invitation_code"
  add_index "artist_tiers", ["show_on_artist_page"], :name => "index_artist_tiers_on_show_on_artist_page"

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.text     "bio"
    t.string   "artist_photo_file_name"
    t.string   "artist_photo_content_type"
    t.datetime "artist_photo_updated_at"
    t.integer  "artist_photo_file_size"
    t.string   "website"
    t.string   "twitter"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.boolean  "featured",                                         :default => false
    t.string   "email",                                            :default => "",    :null => false
    t.string   "encrypted_password",                :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                    :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "artist_product_photo_file_name"
    t.integer  "artist_product_photo_file_size"
    t.string   "artist_product_photo_content_type"
    t.datetime "artist_product_photo_updated_at"
    t.string   "invitation_code"
    t.integer  "artist_tier_id"
    t.string   "main_instrument"
    t.text     "notable_career_moments"
    t.integer  "approver_id"
  end

  add_index "artists", ["approver_id"], :name => "index_artists_on_approver_id"
  add_index "artists", ["artist_tier_id"], :name => "index_artists_on_artist_tier_id"
  add_index "artists", ["cached_slug"], :name => "index_artists_on_cached_slug", :unique => true
  add_index "artists", ["confirmation_token"], :name => "index_artists_on_confirmation_token", :unique => true
  add_index "artists", ["featured"], :name => "index_artists_on_featured"
  add_index "artists", ["reset_password_token"], :name => "index_artists_on_reset_password_token", :unique => true

  create_table "audio_demos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "wet_demo_file_name"
    t.integer  "wet_demo_file_size"
    t.string   "wet_demo_content_type"
    t.datetime "wet_demo_updated_at"
    t.string   "dry_demo_file_name"
    t.integer  "dry_demo_file_size"
    t.string   "dry_demo_content_type"
    t.datetime "dry_demo_updated_at"
    t.integer  "duration_in_seconds"
    t.integer  "brand_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "audio_demos", ["brand_id"], :name => "index_audio_demos_on_brand_id"

  create_table "blog_articles", :force => true do |t|
    t.string   "title"
    t.integer  "blog_id"
    t.date     "post_on"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blog_articles", ["author_id"], :name => "index_blog_articles_on_author_id"
  add_index "blog_articles", ["blog_id"], :name => "index_blog_articles_on_blog_id"

  create_table "blogs", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.integer  "default_article_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "blogs", ["brand_id"], :name => "index_blogs_on_brand_id"

  create_table "brand_distributors", :force => true do |t|
    t.integer  "distributor_id"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_distributors", ["brand_id"], :name => "index_brand_distributors_on_brand_id"
  add_index "brand_distributors", ["distributor_id"], :name => "index_brand_distributors_on_distributor_id"

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.integer  "default_website_id"
    t.boolean  "has_effects",                   :default => false
    t.boolean  "has_reviews",                   :default => true
    t.boolean  "has_faqs",                      :default => true
    t.boolean  "has_tone_library",              :default => false
    t.boolean  "has_artists",                   :default => true
    t.boolean  "has_clinics",                   :default => false
    t.boolean  "has_software",                  :default => true
    t.boolean  "has_registered_downloads",      :default => false
    t.boolean  "has_online_retailers",          :default => true
    t.boolean  "has_distributors",              :default => true
    t.boolean  "has_dealers",                   :default => true
    t.boolean  "has_service_centers",           :default => false
    t.string   "default_locale"
    t.integer  "dealers_from_brand_id"
    t.integer  "distributors_from_brand_id"
    t.boolean  "rso_enabled"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.datetime "logo_updated_at"
    t.integer  "logo_file_size"
    t.string   "news_feed_url"
    t.boolean  "has_market_segments"
    t.boolean  "has_parts_form"
    t.boolean  "has_rma_form"
    t.boolean  "has_training",                  :default => false
    t.integer  "service_centers_from_brand_id"
    t.boolean  "show_pricing"
    t.boolean  "has_suggested_products"
    t.boolean  "has_blogs"
    t.boolean  "has_audio_demos",               :default => false
    t.boolean  "has_vintage_repair"
    t.boolean  "has_label_sheets"
    t.boolean  "employee_store"
    t.boolean  "live_on_this_platform"
  end

  add_index "brands", ["cached_slug"], :name => "index_brands_on_cached_slug", :unique => true

  create_table "cabinets", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "cab_image_file_name"
    t.integer  "cab_image_file_size"
    t.string   "cab_image_content_type"
    t.datetime "cab_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clinic_products", :force => true do |t|
    t.integer  "clinic_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clinician_questions", :force => true do |t|
    t.integer  "clinician_report_id"
    t.integer  "position"
    t.text     "question"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clinician_reports", :force => true do |t|
    t.integer  "clinic_id"
    t.integer  "overall_impression"
    t.text     "regional_competitors"
    t.boolean  "rep_planned"
    t.text     "rep_planned_comments"
    t.text     "best_part"
    t.text     "worst_part"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clinics", :force => true do |t|
    t.datetime "scheduled_at"
    t.integer  "clinician_id"
    t.integer  "dealer_id"
    t.string   "location"
    t.float    "travel_expenses"
    t.float    "food_expenses"
    t.boolean  "increased_sell_through"
    t.boolean  "generated_orders"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rep_id"
    t.float    "total_wages"
    t.datetime "end_at"
  end

  create_table "contact_messages", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product"
    t.string   "operating_system"
    t.string   "message_type"
    t.string   "company"
    t.string   "account_number"
    t.string   "phone"
    t.string   "fax"
    t.string   "billing_address"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip"
    t.string   "shipping_address"
    t.string   "shipping_city"
    t.string   "shipping_state"
    t.string   "shipping_zip"
    t.string   "product_sku"
    t.string   "product_serial_number"
    t.boolean  "warranty"
    t.date     "purchased_on"
    t.string   "part_number"
    t.string   "board_location"
    t.string   "shipping_country"
  end

  create_table "content_translations", :force => true do |t|
    t.string   "content_type"
    t.integer  "content_id"
    t.string   "content_method"
    t.string   "locale"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_translations", ["content_id"], :name => "index_content_translations_on_content_id"
  add_index "content_translations", ["content_method"], :name => "index_content_translations_on_content_method"
  add_index "content_translations", ["content_type", "content_id"], :name => "index_content_translations_on_content_type_and_content_id"
  add_index "content_translations", ["content_type"], :name => "index_content_translations_on_content_type"
  add_index "content_translations", ["locale"], :name => "index_content_translations_on_locale"

  create_table "dealers", :force => true do |t|
    t.string   "name"
    t.string   "name2"
    t.string   "name3"
    t.string   "name4"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "telephone"
    t.string   "fax"
    t.string   "email"
    t.string   "account_number"
    t.decimal  "lat",                :precision => 15, :scale => 10
    t.decimal  "lng",                :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
    t.boolean  "exclude"
    t.boolean  "skip_sync_from_sap"
  end

  add_index "dealers", ["account_number"], :name => "index_dealers_on_account_number"
  add_index "dealers", ["brand_id"], :name => "index_dealers_on_brand_id"
  add_index "dealers", ["exclude"], :name => "index_dealers_on_exclude"
  add_index "dealers", ["lat", "lng"], :name => "index_dealers_on_lat_and_lng"
  add_index "dealers", ["skip_sync_from_sap"], :name => "index_dealers_on_skip_sync_from_sap"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "demo_songs", :force => true do |t|
    t.integer  "product_attachment_id"
    t.integer  "position"
    t.string   "title"
    t.string   "mp3_file_name"
    t.integer  "mp3_file_size"
    t.string   "mp3_content_type"
    t.datetime "mp3_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "demo_songs", ["product_attachment_id"], :name => "index_demo_songs_on_product_attachment_id"

  create_table "distributors", :force => true do |t|
    t.string   "name"
    t.text     "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
  end

  add_index "distributors", ["country"], :name => "index_distributors_on_country"

  create_table "download_registrations", :force => true do |t|
    t.integer  "registered_download_id"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "serial_number"
    t.integer  "download_count"
    t.string   "download_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subscribe"
    t.string   "product"
    t.string   "employee_number"
    t.string   "store_number"
    t.string   "manager_name"
  end

  create_table "effect_types", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "effects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "effect_image_file_name"
    t.integer  "effect_image_file_size"
    t.string   "effect_image_content_type"
    t.datetime "effect_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "effect_type_id"
  end

  add_index "effects", ["effect_type_id"], :name => "index_effects_on_effect_type_id"

  create_table "faqs", :force => true do |t|
    t.integer  "product_id"
    t.text     "question"
    t.text     "answer"
    t.boolean  "hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faqs", ["product_id"], :name => "index_faqs_on_product_id"

  create_table "forem_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "label_sheet_orders", :force => true do |t|
    t.integer  "user_id"
    t.text     "label_sheets"
    t.date     "mailed_on"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.boolean  "subscribe"
    t.string   "secret_code"
  end

  create_table "label_sheets", :force => true do |t|
    t.string   "name"
    t.text     "products"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locale_product_families", :force => true do |t|
    t.string   "locale"
    t.integer  "product_family_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "market_segment_product_families", :force => true do |t|
    t.integer  "market_segment_id"
    t.integer  "product_family_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "market_segments", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.date     "post_on"
    t.string   "title"
    t.text     "body"
    t.text     "keywords"
    t.string   "news_photo_file_name"
    t.integer  "news_photo_file_size"
    t.datetime "news_photo_created_at"
    t.string   "news_photo_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.integer  "brand_id"
  end

  add_index "news", ["brand_id"], :name => "index_news_on_brand_id"
  add_index "news", ["cached_slug"], :name => "index_news_on_cached_slug", :unique => true

  create_table "news_products", :force => true do |t|
    t.integer  "product_id"
    t.integer  "news_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_products", ["news_id"], :name => "index_news_products_on_news_id"
  add_index "news_products", ["product_id"], :name => "index_news_products_on_product_id"

  create_table "online_retailer_links", :force => true do |t|
    t.integer  "product_id"
    t.integer  "brand_id"
    t.integer  "online_retailer_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "link_checked_at"
    t.string   "link_status",        :default => "200"
  end

  add_index "online_retailer_links", ["brand_id"], :name => "index_online_retailer_links_on_brand_id"
  add_index "online_retailer_links", ["online_retailer_id", "brand_id"], :name => "index_online_retailer_links_on_online_retailer_id_and_brand_id"
  add_index "online_retailer_links", ["online_retailer_id", "product_id"], :name => "index_online_retailer_links_on_online_retailer_id_and_product_id"
  add_index "online_retailer_links", ["online_retailer_id"], :name => "index_online_retailer_links_on_online_retailer_id"
  add_index "online_retailer_links", ["product_id"], :name => "index_online_retailer_links_on_product_id"

  create_table "online_retailer_users", :force => true do |t|
    t.integer  "online_retailer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_retailer_users", ["online_retailer_id"], :name => "index_online_retailer_users_on_online_retailer_id"
  add_index "online_retailer_users", ["user_id"], :name => "index_online_retailer_users_on_user_id"

  create_table "online_retailers", :force => true do |t|
    t.string   "name"
    t.string   "retailer_logo_file_name"
    t.integer  "retailer_logo_file_size"
    t.string   "retailer_logo_file_type"
    t.datetime "retailer_logo_updated_at"
    t.boolean  "active",                   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.string   "direct_link"
    t.integer  "preferred"
  end

  add_index "online_retailers", ["cached_slug"], :name => "index_online_retailers_on_cached_slug", :unique => true

  create_table "operating_systems", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "arch"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "keywords"
    t.text     "description"
    t.text     "body"
    t.string   "custom_route"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.integer  "brand_id"
    t.string   "password"
    t.string   "username"
    t.text     "custom_css"
    t.string   "layout_class"
  end

  add_index "pages", ["brand_id"], :name => "index_pages_on_brand_id"
  add_index "pages", ["cached_slug"], :name => "index_pages_on_cached_slug", :unique => true
  add_index "pages", ["custom_route"], :name => "index_pages_on_custom_route"

  create_table "parent_products", :force => true do |t|
    t.integer  "parent_product_id"
    t.integer  "product_id"
    t.integer  "position"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "parent_products", ["parent_product_id"], :name => "index_parent_products_on_parent_product_id"
  add_index "parent_products", ["product_id"], :name => "index_parent_products_on_product_id"

  create_table "pricing_types", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.integer  "pricelist_order"
    t.string   "calculation_method"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "pricing_types", ["brand_id"], :name => "index_pricing_types_on_brand_id"

  create_table "product_amp_models", :force => true do |t|
    t.integer  "product_id"
    t.integer  "amp_model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_amp_models", ["amp_model_id"], :name => "index_product_amp_models_on_amp_model_id"
  add_index "product_amp_models", ["product_id"], :name => "index_product_amp_models_on_product_id"

  create_table "product_attachments", :force => true do |t|
    t.integer  "product_id"
    t.boolean  "primary_photo",                                 :default => false
    t.string   "product_attachment_file_name"
    t.string   "product_attachment_content_type"
    t.datetime "product_attachment_updated_at"
    t.integer  "product_attachment_file_size"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "product_media_file_name"
    t.string   "product_media_content_type"
    t.integer  "product_media_file_size"
    t.datetime "product_media_updated_at"
    t.string   "product_media_thumb_file_name"
    t.string   "product_media_thumb_content_type"
    t.integer  "product_media_thumb_file_size"
    t.datetime "product_media_thumb_updated_at"
    t.integer  "width",                            :limit => 8
    t.integer  "height",                           :limit => 8
    t.string   "songlist_tag"
    t.boolean  "no_lightbox"
    t.boolean  "hide_from_product_page"
    t.text     "product_attachment_meta"
  end

  add_index "product_attachments", ["product_id", "primary_photo"], :name => "index_product_attachments_on_product_id_and_primary_photo"
  add_index "product_attachments", ["product_id"], :name => "index_product_attachments_on_product_id"

  create_table "product_audio_demos", :force => true do |t|
    t.integer  "audio_demo_id"
    t.integer  "product_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "product_audio_demos", ["audio_demo_id"], :name => "index_product_audio_demos_on_audio_demo_id"
  add_index "product_audio_demos", ["product_id"], :name => "index_product_audio_demos_on_product_id"

  create_table "product_cabinets", :force => true do |t|
    t.integer  "product_id"
    t.integer  "cabinet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_cabinets", ["cabinet_id"], :name => "index_product_cabinets_on_cabinet_id"
  add_index "product_cabinets", ["product_id"], :name => "index_product_cabinets_on_product_id"

  create_table "product_documents", :force => true do |t|
    t.integer  "product_id"
    t.string   "language"
    t.string   "document_type"
    t.string   "document_file_name"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "document_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "product_documents", ["cached_slug"], :name => "index_product_documents_on_cached_slug", :unique => true
  add_index "product_documents", ["product_id"], :name => "index_product_documents_on_product_id"

  create_table "product_effects", :force => true do |t|
    t.integer  "product_id"
    t.integer  "effect_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_effects", ["effect_id"], :name => "index_product_effects_on_effect_id"
  add_index "product_effects", ["product_id"], :name => "index_product_effects_on_product_id"

  create_table "product_families", :force => true do |t|
    t.string   "name"
    t.string   "family_photo_file_name"
    t.string   "family_photo_content_type"
    t.datetime "family_photo_updated_at"
    t.integer  "family_photo_file_size"
    t.text     "intro"
    t.integer  "brand_id"
    t.text     "keywords"
    t.integer  "position"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hide_from_homepage",            :default => false
    t.string   "cached_slug"
    t.string   "background_image_file_name"
    t.integer  "background_image_file_size"
    t.string   "background_image_content_type"
    t.datetime "background_image_updated_at"
    t.string   "background_color"
    t.string   "layout_class"
    t.string   "family_banner_file_name"
    t.string   "family_banner_content_type"
    t.integer  "family_banner_file_size"
    t.datetime "family_banner_updated_at"
    t.string   "title_banner_file_name"
    t.string   "title_banner_content_type"
    t.integer  "title_banner_file_size"
    t.datetime "title_banner_updated_at"
  end

  add_index "product_families", ["brand_id"], :name => "index_product_families_on_brand_id"
  add_index "product_families", ["cached_slug"], :name => "index_product_families_on_cached_slug", :unique => true
  add_index "product_families", ["parent_id"], :name => "index_product_families_on_parent_id"

  create_table "product_family_products", :force => true do |t|
    t.integer  "product_id"
    t.integer  "product_family_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_family_products", ["product_family_id"], :name => "index_product_family_products_on_product_family_id"
  add_index "product_family_products", ["product_id"], :name => "index_product_family_products_on_product_id"

  create_table "product_introductions", :force => true do |t|
    t.integer  "product_id"
    t.string   "layout_class"
    t.date     "expires_on"
    t.text     "content"
    t.text     "extra_css"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "top_image_file_name"
    t.integer  "top_image_file_size"
    t.string   "top_image_content_type"
    t.datetime "top_image_updated_at"
    t.string   "box_bg_image_file_name"
    t.integer  "box_bg_image_file_size"
    t.string   "box_bg_image_content_type"
    t.datetime "box_bg_image_updated_at"
    t.string   "page_bg_image_file_name"
    t.integer  "page_bg_image_file_size"
    t.string   "page_bg_image_content_type"
    t.datetime "page_bg_image_updated_at"
  end

  add_index "product_introductions", ["product_id"], :name => "index_product_introductions_on_product_id"

  create_table "product_prices", :force => true do |t|
    t.integer  "product_id"
    t.integer  "pricing_type_id"
    t.integer  "price_cents",     :default => 0,     :null => false
    t.string   "price_currency",  :default => "USD", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "product_prices", ["pricing_type_id"], :name => "index_product_prices_on_pricing_type_id"
  add_index "product_prices", ["product_id"], :name => "index_product_prices_on_product_id"

  create_table "product_promotions", :force => true do |t|
    t.integer  "product_id"
    t.integer  "promotion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_promotions", ["product_id"], :name => "index_product_promotions_on_product_id"
  add_index "product_promotions", ["promotion_id"], :name => "index_product_promotions_on_promotion_id"

  create_table "product_review_products", :force => true do |t|
    t.integer  "product_id"
    t.integer  "product_review_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_review_products", ["product_id"], :name => "index_product_review_products_on_product_id"
  add_index "product_review_products", ["product_review_id"], :name => "index_product_review_products_on_product_review_id"

  create_table "product_reviews", :force => true do |t|
    t.string   "title"
    t.string   "external_link"
    t.text     "body"
    t.string   "review_file_name"
    t.integer  "review_file_size"
    t.string   "review_content_type"
    t.datetime "review_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.datetime "link_checked_at"
    t.string   "link_status",              :default => "200"
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
  end

  add_index "product_reviews", ["cached_slug"], :name => "index_product_reviews_on_cached_slug", :unique => true

  create_table "product_site_elements", :force => true do |t|
    t.integer  "product_id"
    t.integer  "site_element_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "product_site_elements", ["product_id"], :name => "index_product_site_elements_on_product_id"
  add_index "product_site_elements", ["site_element_id"], :name => "index_product_site_elements_on_site_element_id"

  create_table "product_softwares", :force => true do |t|
    t.integer  "product_id"
    t.integer  "software_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_position"
    t.integer  "software_position"
  end

  add_index "product_softwares", ["product_id"], :name => "index_product_softwares_on_product_id"
  add_index "product_softwares", ["software_id"], :name => "index_product_softwares_on_software_id"

  create_table "product_specifications", :force => true do |t|
    t.integer  "product_id"
    t.integer  "specification_id"
    t.string   "value"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_specifications", ["product_id"], :name => "index_product_specifications_on_product_id"
  add_index "product_specifications", ["specification_id"], :name => "index_product_specifications_on_specification_id"

  create_table "product_statuses", :force => true do |t|
    t.string   "name"
    t.boolean  "show_on_website", :default => false
    t.boolean  "discontinued",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shipping",        :default => false
  end

  create_table "product_suggestions", :force => true do |t|
    t.integer  "product_id"
    t.integer  "suggested_product_id"
    t.integer  "position"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "product_training_classes", :force => true do |t|
    t.integer  "product_id"
    t.integer  "training_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_training_modules", :force => true do |t|
    t.integer  "product_id"
    t.integer  "training_module_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "sap_sku"
    t.text     "description"
    t.text     "short_description"
    t.text     "keywords"
    t.integer  "product_status_id"
    t.boolean  "rohs",                          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "extended_description"
    t.string   "cached_slug"
    t.string   "background_image_file_name"
    t.integer  "background_image_file_size"
    t.string   "background_image_content_type"
    t.datetime "background_image_updated_at"
    t.string   "background_color"
    t.text     "features"
    t.string   "password"
    t.text     "previewers"
    t.boolean  "has_pedals",                    :default => false
    t.integer  "brand_id"
    t.integer  "warranty_period"
    t.float    "sale_price"
    t.float    "msrp"
    t.string   "layout_class"
    t.string   "direct_buy_link"
    t.float    "street_price"
    t.string   "features_tab_name"
    t.string   "demo_link"
    t.float    "harman_employee_price"
    t.boolean  "hide_buy_it_now_button"
    t.string   "more_info_url"
  end

  add_index "products", ["brand_id", "product_status_id"], :name => "index_products_on_brand_id_and_product_status_id"
  add_index "products", ["brand_id"], :name => "index_products_on_brand_id"
  add_index "products", ["cached_slug"], :name => "index_products_on_cached_slug", :unique => true

  create_table "promotions", :force => true do |t|
    t.string   "name"
    t.date     "show_start_on"
    t.date     "show_end_on"
    t.date     "start_on"
    t.date     "end_on"
    t.text     "description"
    t.string   "promo_form_file_name"
    t.integer  "promo_form_file_size"
    t.datetime "promo_form_updated_at"
    t.string   "promo_form_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.string   "tile_file_name"
    t.integer  "tile_file_size"
    t.string   "tile_content_type"
    t.datetime "tile_updated_at"
    t.string   "post_registration_subject"
    t.text     "post_registration_message"
    t.boolean  "send_post_registration_message", :default => false
    t.integer  "brand_id"
  end

  add_index "promotions", ["cached_slug"], :name => "index_promotions_on_cached_slug", :unique => true

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "coordinates"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registered_downloads", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.string   "protected_software_file_name"
    t.integer  "protected_software_file_size"
    t.string   "protected_software_content_type"
    t.datetime "protected_software_updated_at"
    t.integer  "download_count"
    t.text     "html_template"
    t.text     "intro_page_content"
    t.text     "confirmation_page_content"
    t.text     "email_template"
    t.text     "download_page_content"
    t.string   "url"
    t.string   "valid_code"
    t.integer  "per_download_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from_email"
    t.string   "subject"
    t.boolean  "require_serial_number"
    t.string   "cc"
    t.text     "products"
    t.boolean  "require_employee_number"
    t.boolean  "require_store_number"
    t.boolean  "require_manager_name"
    t.boolean  "send_coupon_code"
    t.text     "coupon_codes"
  end

  create_table "rep_questions", :force => true do |t|
    t.integer  "rep_report_id"
    t.integer  "position"
    t.text     "question"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rep_reports", :force => true do |t|
    t.integer  "clinic_id"
    t.integer  "overall_impression"
    t.integer  "clinician_preparation"
    t.text     "clinician_preparation_comments"
    t.boolean  "clinician_on_time"
    t.integer  "attendance"
    t.boolean  "rebook_clinician"
    t.text     "best_part"
    t.text     "worst_part"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rso_monthly_reports", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "brand_id"
    t.string   "rso_report_file_name"
    t.integer  "rso_report_file_size"
    t.string   "rso_report_content_type"
    t.datetime "rso_report_updated_at"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rso_navigations", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "position"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rso_panel_id"
  end

  create_table "rso_pages", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rso_panels", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.text     "content"
    t.string   "rso_panel_image_file_name"
    t.string   "rso_panel_image_content_type"
    t.integer  "rso_panel_image_file_size"
    t.datetime "rso_panel_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "rso_personal_reports", :force => true do |t|
    t.integer  "user_id"
    t.string   "rso_personal_report_file_name"
    t.integer  "rso_personal_report_file_size"
    t.string   "rso_personal_report_content_type"
    t.datetime "rso_personal_report_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rso_settings", :force => true do |t|
    t.string   "name"
    t.string   "setting_type",  :default => "string"
    t.string   "string_value"
    t.integer  "integer_value"
    t.text     "text_value"
    t.text     "html_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_centers", :force => true do |t|
    t.string   "name",           :limit => 100
    t.string   "name2",          :limit => 100
    t.string   "name3",          :limit => 100
    t.string   "name4",          :limit => 100
    t.string   "address",        :limit => 100
    t.string   "city",           :limit => 100
    t.string   "state",          :limit => 50
    t.string   "zip",            :limit => 40
    t.string   "telephone",      :limit => 40
    t.string   "fax",            :limit => 40
    t.string   "email",          :limit => 100
    t.string   "account_number", :limit => 50
    t.string   "website",        :limit => 100
    t.decimal  "lat",                           :precision => 15, :scale => 10
    t.decimal  "lng",                           :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
    t.boolean  "vintage"
  end

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "setting_type"
    t.string   "string_value"
    t.integer  "integer_value"
    t.text     "text_value"
    t.string   "slide_file_name"
    t.integer  "slide_file_size"
    t.string   "locale"
    t.integer  "brand_id"
    t.string   "slide_content_type"
    t.datetime "slide_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["brand_id", "name", "locale"], :name => "index_settings_on_brand_id_and_name_and_locale"
  add_index "settings", ["brand_id", "name"], :name => "index_settings_on_brand_id_and_name"
  add_index "settings", ["brand_id"], :name => "index_settings_on_brand_id"

  create_table "site_elements", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.string   "resource_file_name"
    t.integer  "resource_file_size"
    t.string   "resource_content_type"
    t.datetime "resource_updated_at"
    t.string   "resource_type"
    t.boolean  "show_on_public_site"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "executable_file_name"
    t.string   "executable_content_type"
    t.integer  "executable_file_size"
    t.datetime "executable_updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "software_activations", :force => true do |t|
    t.integer  "software_id"
    t.string   "challenge"
    t.string   "activation_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "software_attachments", :force => true do |t|
    t.integer  "software_id"
    t.string   "software_attachment_file_name"
    t.integer  "software_attachment_file_size"
    t.string   "software_attachment_content_type"
    t.datetime "software_attachment_updated_at"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "software_operating_systems", :force => true do |t|
    t.integer  "software_id"
    t.integer  "operating_system_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "software_operating_systems", ["operating_system_id"], :name => "index_software_operating_systems_on_operating_system_id"
  add_index "software_operating_systems", ["software_id"], :name => "index_software_operating_systems_on_software_id"

  create_table "software_training_classes", :force => true do |t|
    t.integer  "software_id"
    t.integer  "training_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "software_training_modules", :force => true do |t|
    t.integer  "software_id"
    t.integer  "training_module_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "softwares", :force => true do |t|
    t.string   "name"
    t.string   "ware_file_name"
    t.integer  "ware_file_size"
    t.string   "ware_content_type"
    t.datetime "ware_updated_at"
    t.integer  "download_count"
    t.string   "version"
    t.text     "description"
    t.string   "platform"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.string   "cached_slug"
    t.integer  "brand_id"
    t.string   "link"
    t.text     "multipliers"
    t.string   "activation_name"
    t.datetime "link_checked_at"
    t.string   "link_status",        :default => "200"
    t.string   "layout_class"
    t.integer  "current_version_id"
    t.string   "bit"
  end

  add_index "softwares", ["cached_slug"], :name => "index_softwares_on_cached_slug", :unique => true

  create_table "specifications", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "specifications", ["cached_slug"], :name => "index_specifications_on_cached_slug", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tone_library_patches", :force => true do |t|
    t.integer  "tone_library_song_id"
    t.integer  "product_id"
    t.string   "patch_file_name"
    t.integer  "patch_file_size"
    t.datetime "patch_updated_at"
    t.string   "patch_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tone_library_songs", :force => true do |t|
    t.string   "artist_name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "training_classes", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "language"
    t.integer  "instructor_id"
    t.string   "more_info_url"
    t.integer  "region_id"
    t.string   "location"
    t.boolean  "filled"
    t.string   "class_info_file_name"
    t.integer  "class_info_file_size"
    t.string   "class_info_content_type"
    t.datetime "class_info_updated_at"
    t.boolean  "canceled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "training_modules", :force => true do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.string   "training_module_file_name"
    t.string   "training_module_content_type"
    t.integer  "training_module_file_size"
    t.datetime "training_module_updated_at"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "tweets", :force => true do |t|
    t.integer  "brand_id"
    t.string   "tweet_id"
    t.string   "screen_name"
    t.text     "content"
    t.string   "profile_image_url"
    t.datetime "posted_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "tweets", ["brand_id"], :name => "index_tweets_on_brand_id"
  add_index "tweets", ["tweet_id"], :name => "index_tweets_on_tweet_id"
  add_index "tweets", ["tweet_id"], :name => "tweet_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
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
    t.boolean  "clinic_admin"
    t.string   "name"
    t.boolean  "rso"
    t.boolean  "rso_admin"
    t.boolean  "sales_admin"
    t.boolean  "dealer"
    t.boolean  "distributor"
    t.boolean  "marketing_staff"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "warranty_registrations", :force => true do |t|
    t.string   "title",               :limit => 10
    t.string   "first_name",          :limit => 100
    t.string   "last_name",           :limit => 100
    t.string   "middle_initial",      :limit => 4
    t.string   "company",             :limit => 100
    t.string   "jobtitle",            :limit => 100
    t.string   "address1"
    t.string   "city",                :limit => 100
    t.string   "state",               :limit => 100
    t.string   "zip",                 :limit => 100
    t.string   "country",             :limit => 100
    t.string   "phone",               :limit => 50
    t.string   "fax",                 :limit => 50
    t.string   "email",               :limit => 100
    t.boolean  "subscribe"
    t.integer  "brand_id"
    t.integer  "product_id"
    t.string   "serial_number",       :limit => 100
    t.date     "registered_on"
    t.date     "purchased_on"
    t.string   "purchased_from",      :limit => 100
    t.string   "purchase_country",    :limit => 100
    t.string   "purchase_price",      :limit => 100
    t.string   "age",                 :limit => 40
    t.string   "marketing_question1", :limit => 100
    t.string   "marketing_question2", :limit => 100
    t.string   "marketing_question3", :limit => 100
    t.string   "marketing_question4", :limit => 100
    t.string   "marketing_question5", :limit => 100
    t.string   "marketing_question6", :limit => 100
    t.string   "marketing_question7", :limit => 100
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exported",                           :default => false
  end

  add_index "warranty_registrations", ["exported"], :name => "index_warranty_registrations_on_exported"

  create_table "website_locales", :force => true do |t|
    t.integer  "website_id"
    t.string   "locale"
    t.string   "name"
    t.boolean  "complete",   :default => false
    t.boolean  "default",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "website_locales", ["locale", "website_id"], :name => "index_website_locales_on_locale_and_website_id"

  create_table "websites", :force => true do |t|
    t.string   "url"
    t.integer  "brand_id"
    t.string   "folder"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
    t.string   "default_locale"
  end

  add_index "websites", ["brand_id"], :name => "index_websites_on_brand_id"
  add_index "websites", ["url"], :name => "index_websites_on_url", :unique => true

end
