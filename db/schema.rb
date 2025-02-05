# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_04_201139) do
  create_table "access_levels", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "distributor"
    t.boolean "dealer"
    t.boolean "technician"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "super_technician", default: false
    t.integer "keys"
  end

  create_table "admin_logs", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "user_id"
    t.text "action"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "website_id"
    t.index ["user_id"], name: "index_admin_logs_on_user_id"
    t.index ["website_id"], name: "index_admin_logs_on_website_id"
  end

  create_table "amx_dxlink_attribute_names", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
  end

  create_table "amx_dxlink_combo_attributes", charset: "utf8", force: :cascade do |t|
    t.string "value"
    t.bigint "amx_dxlink_attribute_name_id", null: false
    t.bigint "amx_dxlink_combo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amx_dxlink_attribute_name_id"], name: "idx_dxlink_combo_attr_on_attr_name_id"
    t.index ["amx_dxlink_combo_id"], name: "index_amx_dxlink_combo_attributes_on_amx_dxlink_combo_id"
  end

  create_table "amx_dxlink_combos", charset: "utf8", force: :cascade do |t|
    t.boolean "recommended"
    t.text "notes"
    t.bigint "tx_id", null: false
    t.bigint "rx_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rx_id"], name: "index_amx_dxlink_combos_on_rx_id"
    t.index ["tx_id"], name: "index_amx_dxlink_combos_on_tx_id"
  end

  create_table "amx_dxlink_device_infos", charset: "utf8", force: :cascade do |t|
    t.string "model"
    t.string "model_family"
    t.string "type_long_name"
    t.string "type_short_name"
    t.string "product_url"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "amx_itg_new_module_requests", charset: "utf8", force: :cascade do |t|
    t.string "device_type"
    t.string "manufacturer"
    t.text "models"
    t.string "method_of_control"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.bigint "attachment_file_size"
    t.datetime "attachment_updated_at", precision: nil
    t.text "additional_notes"
    t.string "project_type"
    t.text "other_project_type"
    t.string "num_systems"
    t.string "amx_controller_types"
    t.text "other_amx_controller_type"
    t.string "num_devices_using_module"
    t.date "expected_installation_date"
    t.string "requestor"
    t.string "region"
    t.string "company"
    t.string "phone"
    t.string "email"
    t.string "harman_account_manager"
    t.text "additional_info"
    t.boolean "agree_to_validate_onsite"
    t.boolean "agree_device_has_api_feeback"
    t.boolean "agree_to_recieve_emails"
    t.string "contact_name"
    t.string "contact_email"
    t.string "direct_upload_url"
    t.boolean "processed", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "amx_partner_interest_forms", charset: "utf8", force: :cascade do |t|
    t.string "company_name"
    t.string "company_url"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.string "product_target_market_segment"
    t.string "partnership_interest"
    t.text "additional_comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_keys", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "description"
  end

  create_table "artist_brands", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "brand_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "intro"
    t.index ["artist_id"], name: "index_artist_brands_on_artist_id"
    t.index ["brand_id"], name: "index_artist_brands_on_brand_id"
  end

  create_table "artist_products", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "product_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "quote"
    t.boolean "on_tour", default: false
    t.boolean "favorite"
    t.index ["artist_id", "favorite"], name: "index_artist_products_on_artist_id_and_favorite"
    t.index ["artist_id"], name: "index_artist_products_on_artist_id"
    t.index ["product_id", "on_tour"], name: "index_artist_products_on_product_id_and_on_tour"
    t.index ["product_id"], name: "index_artist_products_on_product_id"
  end

  create_table "artist_tiers", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "invitation_code"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "show_on_artist_page"
    t.integer "position"
    t.index ["invitation_code"], name: "index_artist_tiers_on_invitation_code"
    t.index ["show_on_artist_page"], name: "index_artist_tiers_on_show_on_artist_page"
  end

  create_table "artists", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.string "artist_photo_file_name"
    t.string "artist_photo_content_type"
    t.datetime "artist_photo_updated_at", precision: nil
    t.integer "artist_photo_file_size"
    t.string "website"
    t.string "twitter"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.boolean "featured", default: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "artist_product_photo_file_name"
    t.integer "artist_product_photo_file_size"
    t.string "artist_product_photo_content_type"
    t.datetime "artist_product_photo_updated_at", precision: nil
    t.string "invitation_code"
    t.integer "artist_tier_id"
    t.string "main_instrument"
    t.text "notable_career_moments"
    t.integer "approver_id"
    t.index ["approver_id"], name: "index_artists_on_approver_id"
    t.index ["artist_tier_id"], name: "index_artists_on_artist_tier_id"
    t.index ["cached_slug"], name: "index_artists_on_cached_slug", unique: true
    t.index ["confirmation_token"], name: "index_artists_on_confirmation_token", unique: true
    t.index ["featured"], name: "index_artists_on_featured"
    t.index ["reset_password_token"], name: "index_artists_on_reset_password_token", unique: true
  end

  create_table "audio_demos", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "wet_demo_file_name"
    t.integer "wet_demo_file_size"
    t.string "wet_demo_content_type"
    t.datetime "wet_demo_updated_at", precision: nil
    t.string "dry_demo_file_name"
    t.integer "dry_demo_file_size"
    t.string "dry_demo_content_type"
    t.datetime "dry_demo_updated_at", precision: nil
    t.integer "duration_in_seconds"
    t.integer "brand_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["brand_id"], name: "index_audio_demos_on_brand_id"
  end

  create_table "bad_actor_logs", charset: "utf8", force: :cascade do |t|
    t.string "ip_address"
    t.string "reason"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_bad_actor_logs_on_ip_address"
  end

  create_table "badges", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "banner_locales", charset: "utf8", force: :cascade do |t|
    t.bigint "banner_id", null: false
    t.string "locale", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "slide_file_name"
    t.string "slide_content_type"
    t.datetime "slide_updated_at"
    t.integer "slide_file_size"
    t.text "content"
    t.text "css"
    t.string "link"
    t.boolean "default"
    t.index ["banner_id"], name: "index_banner_locales_on_banner_id"
    t.index ["locale"], name: "index_banner_locales_on_locale"
  end

  create_table "banners", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "bannerable_type", null: false
    t.bigint "bannerable_id", null: false
    t.date "start_on"
    t.date "remove_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bannerable_type", "bannerable_id"], name: "index_banners_on_bannerable"
  end

  create_table "brand_dealer_rental_products", charset: "utf8", force: :cascade do |t|
    t.bigint "brand_dealer_id"
    t.bigint "product_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brand_dealers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "brand_id"
    t.integer "dealer_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["brand_id"], name: "index_brand_dealers_on_brand_id"
    t.index ["dealer_id"], name: "index_brand_dealers_on_dealer_id"
  end

  create_table "brand_distributors", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "distributor_id"
    t.integer "brand_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["brand_id"], name: "index_brand_distributors_on_brand_id"
    t.index ["distributor_id"], name: "index_brand_distributors_on_distributor_id"
  end

  create_table "brand_news", charset: "utf8", force: :cascade do |t|
    t.integer "brand_id"
    t.integer "news_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_brand_news_on_brand_id"
    t.index ["news_id"], name: "index_brand_news_on_news_id"
  end

  create_table "brand_solution_featured_products", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "brand_id"
    t.integer "solution_id"
    t.integer "product_id"
    t.string "name"
    t.string "link"
    t.text "description"
    t.string "image_file_name"
    t.string "image_content_type"
    t.datetime "image_updated_at", precision: nil
    t.integer "image_file_size"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position"
    t.index ["brand_id"], name: "index_brand_solution_featured_products_on_brand_id"
    t.index ["solution_id"], name: "index_brand_solution_featured_products_on_solution_id"
  end

  create_table "brand_solutions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "brand_id"
    t.integer "solution_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["brand_id"], name: "index_brand_solutions_on_brand_id"
    t.index ["solution_id"], name: "index_brand_solutions_on_solution_id"
  end

  create_table "brand_specification_for_comparisons", charset: "utf8", force: :cascade do |t|
    t.integer "brand_id"
    t.integer "specification_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["brand_id"], name: "index_brand_specification_for_comparisons_on_brand_id"
    t.index ["specification_id"], name: "index_brand_specification_for_comparisons_on_specification_id"
  end

  create_table "brands", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.integer "default_website_id"
    t.boolean "has_effects", default: false
    t.boolean "has_reviews", default: true
    t.boolean "has_faqs", default: true
    t.boolean "has_artists", default: true
    t.boolean "has_software", default: true
    t.boolean "has_registered_downloads", default: false
    t.boolean "has_online_retailers", default: true
    t.boolean "has_distributors", default: true
    t.boolean "has_dealers", default: true
    t.boolean "has_service_centers", default: false
    t.string "default_locale"
    t.integer "dealers_from_brand_id"
    t.integer "distributors_from_brand_id"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.datetime "logo_updated_at", precision: nil
    t.integer "logo_file_size"
    t.string "news_feed_url"
    t.boolean "has_market_segments"
    t.boolean "has_parts_form"
    t.boolean "has_rma_form"
    t.boolean "has_training", default: false
    t.integer "service_centers_from_brand_id"
    t.boolean "show_pricing"
    t.boolean "has_suggested_products"
    t.boolean "has_blogs"
    t.boolean "has_audio_demos", default: false
    t.boolean "has_vintage_repair"
    t.boolean "employee_store"
    t.boolean "live_on_this_platform"
    t.boolean "product_trees"
    t.boolean "has_us_sales_reps"
    t.integer "us_sales_reps_from_brand_id"
    t.boolean "queue"
    t.boolean "toolkit"
    t.string "color"
    t.boolean "has_products"
    t.boolean "has_system_configurator", default: false
    t.boolean "offers_rentals"
    t.boolean "has_installations"
    t.boolean "has_product_registrations", default: true
    t.boolean "has_get_started_pages", default: false
    t.boolean "has_events", default: false
    t.boolean "has_solution_pages", default: false
    t.boolean "show_enterprise_solutions"
    t.boolean "show_entertainment_solutions"
    t.boolean "send_contact_form_to_distributors"
    t.boolean "has_photometrics"
    t.boolean "dealers_are_us_only", default: true
    t.boolean "dealers_include_rental_and_service", default: false
    t.boolean "has_parts_library"
    t.boolean "send_contact_form_to_regional_support", default: false
    t.boolean "always_redirect_to_youtube", default: false
    t.boolean "show_consultant_button"
    t.boolean "has_product_selector"
    t.boolean "show_lead_form_on_buy_page", default: false
    t.boolean "harman_owned", default: true
    t.boolean "collapse_content", default: false
    t.boolean "redirect_product_pages_to_parent_brand"
    t.index ["cached_slug"], name: "index_brands_on_cached_slug", unique: true
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "contact_messages", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "message"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "product"
    t.string "operating_system"
    t.string "message_type"
    t.string "company"
    t.string "account_number"
    t.string "phone"
    t.string "fax"
    t.string "billing_address"
    t.string "billing_city"
    t.string "billing_state"
    t.string "billing_zip"
    t.string "shipping_address"
    t.string "shipping_city"
    t.string "shipping_state"
    t.string "shipping_zip"
    t.string "product_sku"
    t.string "product_serial_number"
    t.boolean "warranty"
    t.date "purchased_on"
    t.string "part_number"
    t.string "board_location"
    t.string "shipping_country"
    t.integer "brand_id"
    t.index ["brand_id"], name: "index_contact_messages_on_brand_id"
  end

  create_table "content_translations", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "content_type"
    t.integer "content_id"
    t.string "content_method"
    t.string "locale"
    t.text "content"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["content_id"], name: "index_content_translations_on_content_id"
    t.index ["content_method"], name: "index_content_translations_on_content_method"
    t.index ["content_type", "content_id"], name: "index_content_translations_on_content_type_and_content_id"
    t.index ["content_type"], name: "index_content_translations_on_content_type"
    t.index ["locale"], name: "index_content_translations_on_locale"
  end

  create_table "current_product_counts", charset: "utf8", force: :cascade do |t|
    t.integer "product_family_id"
    t.string "locale"
    t.integer "current_products_plus_child_products_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_family_id"], name: "index_current_product_counts_on_product_family_id"
  end

  create_table "custom_shop_carts", charset: "utf8", force: :cascade do |t|
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_custom_shop_carts_on_uuid"
  end

  create_table "custom_shop_line_item_attributes", charset: "utf8", force: :cascade do |t|
    t.integer "custom_shop_line_item_id"
    t.integer "customizable_attribute_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_value"
  end

  create_table "custom_shop_line_items", charset: "utf8", force: :cascade do |t|
    t.integer "custom_shop_price_request_id"
    t.integer "custom_shop_cart_id"
    t.integer "product_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents"
    t.string "model"
    t.index ["custom_shop_cart_id"], name: "index_custom_shop_line_items_on_custom_shop_cart_id"
    t.index ["custom_shop_price_request_id"], name: "index_custom_shop_line_items_on_custom_shop_price_request_id"
  end

  create_table "custom_shop_price_requests", charset: "utf8", force: :cascade do |t|
    t.string "uuid"
    t.integer "user_id"
    t.string "account_number"
    t.string "opportunity_number"
    t.string "opportunity_name"
    t.string "location"
    t.text "description"
    t.date "request_delivery_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "custom_shop_cart_id"
    t.string "status"
    t.index ["custom_shop_cart_id"], name: "index_custom_shop_price_requests_on_custom_shop_cart_id"
    t.index ["user_id"], name: "index_custom_shop_price_requests_on_user_id"
  end

  create_table "customizable_attribute_values", charset: "utf8", force: :cascade do |t|
    t.integer "customizable_attribute_id"
    t.integer "product_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment"
    t.string "code"
  end

  create_table "customizable_attributes", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment"
  end

  create_table "dealer_users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "dealer_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["dealer_id"], name: "index_dealer_users_on_dealer_id"
    t.index ["user_id"], name: "index_dealer_users_on_user_id"
  end

  create_table "dealers", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "name2"
    t.string "name3"
    t.string "name4"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "telephone"
    t.string "fax"
    t.string "email"
    t.string "account_number"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lng", precision: 15, scale: 10
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "exclude"
    t.boolean "skip_sync_from_sap"
    t.string "website"
    t.string "google_map_place_id"
    t.string "country"
    t.boolean "resale", default: true
    t.boolean "rush", default: false
    t.boolean "rental", default: false
    t.boolean "installation", default: false
    t.string "represented_in_country"
    t.boolean "service", default: false
    t.string "products"
    t.string "region"
    t.index ["account_number"], name: "index_dealers_on_account_number"
    t.index ["exclude"], name: "index_dealers_on_exclude"
    t.index ["lat", "lng"], name: "index_dealers_on_lat_and_lng"
    t.index ["region"], name: "index_dealers_on_region"
    t.index ["skip_sync_from_sap"], name: "index_dealers_on_skip_sync_from_sap"
  end

  create_table "delayed_jobs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "queue"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "distributor_users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "distributor_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["distributor_id"], name: "index_distributor_users_on_distributor_id"
    t.index ["user_id"], name: "index_distributor_users_on_user_id"
  end

  create_table "distributors", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "detail"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "country"
    t.string "email"
    t.string "account_number"
    t.index ["account_number"], name: "index_distributors_on_account_number"
    t.index ["country"], name: "index_distributors_on_country"
    t.index ["email"], name: "index_distributors_on_email"
  end

  create_table "download_registrations", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "registered_download_id"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "serial_number"
    t.integer "download_count"
    t.string "download_code"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "subscribe"
    t.string "product"
    t.string "employee_number"
    t.string "store_number"
    t.string "manager_name"
    t.string "receipt_file_name"
    t.integer "receipt_file_size"
    t.string "receipt_content_type"
    t.datetime "receipt_updated_at", precision: nil
    t.string "country"
  end

  create_table "effect_types", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "effects", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "effect_image_file_name"
    t.integer "effect_image_file_size"
    t.string "effect_image_content_type"
    t.datetime "effect_image_updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "effect_type_id"
    t.string "cached_slug"
    t.index ["cached_slug"], name: "index_effects_on_cached_slug"
    t.index ["effect_type_id"], name: "index_effects_on_effect_type_id"
  end

  create_table "events", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "page_content"
    t.string "cached_slug"
    t.date "start_on"
    t.date "end_on"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.boolean "active", default: false
    t.string "more_info_link"
    t.boolean "new_window"
    t.integer "brand_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["brand_id"], name: "index_events_on_brand_id"
    t.index ["cached_slug"], name: "index_events_on_cached_slug", unique: true
  end

  create_table "faq_categories", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["brand_id"], name: "index_faq_categories_on_brand_id"
  end

  create_table "faq_category_faqs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "faq_category_id"
    t.integer "faq_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["faq_category_id"], name: "index_faq_category_faqs_on_faq_category_id"
    t.index ["faq_id"], name: "index_faq_category_faqs_on_faq_id"
  end

  create_table "faqs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.text "question"
    t.text "answer"
    t.boolean "hidden"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["product_id"], name: "index_faqs_on_product_id"
  end

  create_table "features", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "featurable_id"
    t.string "featurable_type"
    t.integer "position"
    t.string "layout_style"
    t.string "content_position"
    t.text "pre_content"
    t.text "content"
    t.string "image_file_name"
    t.string "image_content_type"
    t.datetime "image_updated_at", precision: nil
    t.integer "image_file_size"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "use_as_banner_slide", default: false
    t.boolean "show_below_products", default: false
    t.boolean "show_below_videos", default: false
    t.string "video_file_name"
    t.string "video_content_type"
    t.datetime "video_updated_at"
    t.integer "video_file_size"
    t.text "custom_css"
    t.index ["featurable_type", "featurable_id"], name: "index_features_on_featurable_type_and_featurable_id"
  end

  create_table "fixtures_requests", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "country"
    t.string "email"
    t.string "lighting_controller"
    t.string "manufacturer"
    t.string "fixture_name"
    t.string "product_link"
    t.string "required_modes"
    t.text "notes"
    t.date "required_on"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "friendly_id_slugs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "slug"
    t.integer "sluggable_id"
    t.string "sluggable_type", limit: 40
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "get_started_page_products", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "get_started_page_id"
    t.integer "product_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["get_started_page_id"], name: "index_get_started_page_products_on_get_started_page_id"
    t.index ["product_id"], name: "index_get_started_page_products_on_product_id"
  end

  create_table "get_started_pages", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "header_image_file_name"
    t.string "header_image_content_type"
    t.integer "header_image_file_size"
    t.datetime "header_image_updated_at", precision: nil
    t.text "intro"
    t.text "details"
    t.integer "brand_id"
    t.string "cached_slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "require_registration_to_unlock_panels", default: true
    t.index ["brand_id"], name: "index_get_started_pages_on_brand_id"
    t.index ["cached_slug"], name: "index_get_started_pages_on_cached_slug", unique: true
  end

  create_table "get_started_panels", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "get_started_page_id"
    t.integer "position"
    t.boolean "locked_until_registration", default: true
    t.string "name"
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "installations", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "brand_id"
    t.string "title"
    t.string "keywords"
    t.text "description"
    t.text "body"
    t.string "custom_route"
    t.string "cached_slug"
    t.text "custom_css"
    t.string "layout_class"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "summary"
    t.string "thumbnail_file_name"
    t.string "thumbnail_content_type"
    t.integer "thumbnail_file_size"
    t.datetime "thumbnail_updated_at", precision: nil
    t.index ["brand_id"], name: "index_installations_on_brand_id"
  end

  create_table "jbl_vertec_vtx_owners", charset: "utf8", force: :cascade do |t|
    t.string "company_name", limit: 100
    t.string "address", limit: 100
    t.string "city", limit: 100
    t.string "state", limit: 50
    t.string "postal_code", limit: 40
    t.string "country", limit: 100
    t.string "phone", limit: 100
    t.string "email", limit: 100
    t.string "website", limit: 100
    t.string "contact_name", limit: 100
    t.string "rental_products"
    t.text "comment"
    t.boolean "approved", default: false
    t.string "approved_by"
    t.integer "dealer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.string "email"
    t.string "phone"
    t.text "project_description"
    t.string "source"
    t.string "city"
    t.string "state"
    t.string "country"
    t.boolean "subscribe", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locale_product_families", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "locale"
    t.integer "product_family_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "locale_softwares", charset: "utf8", force: :cascade do |t|
    t.string "locale"
    t.integer "software_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["software_id"], name: "index_locale_softwares_on_software_id"
  end

  create_table "locales", charset: "utf8", force: :cascade do |t|
    t.string "code", limit: 12
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_locales_on_code"
  end

  create_table "manufacturer_partners", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.boolean "amx_device_discovery"
    t.integer "site_element_id"
    t.index ["site_element_id"], name: "index_manufacturer_partners_on_site_element_id"
  end

  create_table "market_segment_product_families", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "market_segment_id"
    t.integer "product_family_id"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "market_segments", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.string "banner_image_file_name"
    t.string "banner_image_content_type"
    t.integer "banner_image_file_size"
    t.datetime "banner_image_updated_at", precision: nil
    t.integer "parent_id"
    t.integer "position"
    t.text "description"
    t.boolean "hide_page_title"
    t.text "custom_css"
    t.text "custom_js"
    t.index ["brand_id"], name: "index_market_segments_on_brand_id"
    t.index ["cached_slug"], name: "index_market_segments_on_cached_slug"
  end

  create_table "media_translations", charset: "utf8", force: :cascade do |t|
    t.string "media_type"
    t.integer "media_id"
    t.string "media_method"
    t.string "locale"
    t.string "media_file_name"
    t.string "media_content_type"
    t.integer "media_file_size"
    t.datetime "media_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_media_translations_on_locale"
    t.index ["media_type", "media_id"], name: "index_media_translations_on_media_type_and_media_id"
  end

  create_table "news", id: :integer, charset: "utf8", force: :cascade do |t|
    t.date "post_on"
    t.string "title"
    t.text "body"
    t.text "keywords"
    t.string "news_photo_file_name"
    t.integer "news_photo_file_size"
    t.datetime "news_photo_updated_at", precision: nil
    t.string "news_photo_content_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.text "quote"
    t.string "video_ids"
    t.string "old_id"
    t.string "old_url"
    t.string "square_file_name"
    t.string "square_content_type"
    t.integer "square_file_size"
    t.datetime "square_updated_at"
    t.index ["cached_slug"], name: "index_news_on_cached_slug", unique: true
    t.index ["old_id"], name: "index_news_on_old_id"
  end

  create_table "news_images", charset: "utf8", force: :cascade do |t|
    t.integer "news_id"
    t.boolean "hide_from_page"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["news_id"], name: "index_news_images_on_news_id"
  end

  create_table "news_products", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "news_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["news_id"], name: "index_news_products_on_news_id"
    t.index ["product_id"], name: "index_news_products_on_product_id"
  end

  create_table "online_retailer_links", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "brand_id"
    t.integer "online_retailer_id"
    t.string "url"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "link_checked_at", precision: nil
    t.string "link_status", default: "200"
    t.integer "position"
    t.boolean "exclusive", default: false
    t.index ["brand_id"], name: "index_online_retailer_links_on_brand_id"
    t.index ["online_retailer_id", "brand_id"], name: "index_online_retailer_links_on_online_retailer_id_and_brand_id"
    t.index ["online_retailer_id", "product_id"], name: "index_online_retailer_links_on_online_retailer_id_and_product_id"
    t.index ["online_retailer_id"], name: "index_online_retailer_links_on_online_retailer_id"
    t.index ["product_id"], name: "index_online_retailer_links_on_product_id"
  end

  create_table "online_retailer_users", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "online_retailer_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["online_retailer_id"], name: "index_online_retailer_users_on_online_retailer_id"
    t.index ["user_id"], name: "index_online_retailer_users_on_user_id"
  end

  create_table "online_retailers", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "retailer_logo_file_name"
    t.integer "retailer_logo_file_size"
    t.string "retailer_logo_content_type"
    t.datetime "retailer_logo_updated_at", precision: nil
    t.boolean "active", default: true
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.string "direct_link"
    t.integer "preferred"
    t.index ["cached_slug"], name: "index_online_retailers_on_cached_slug", unique: true
  end

  create_table "operating_systems", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.string "arch"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pages", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.string "keywords"
    t.text "description"
    t.text "body", size: :medium
    t.string "custom_route"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.integer "brand_id"
    t.string "password"
    t.string "username"
    t.text "custom_css"
    t.string "layout_class"
    t.text "custom_js"
    t.boolean "exclude_from_search", default: false
    t.index ["brand_id"], name: "index_pages_on_brand_id"
    t.index ["cached_slug"], name: "index_pages_on_cached_slug", unique: true
    t.index ["custom_route"], name: "index_pages_on_custom_route"
  end

  create_table "parent_products", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "parent_product_id"
    t.integer "product_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["parent_product_id"], name: "index_parent_products_on_parent_product_id"
    t.index ["product_id"], name: "index_parent_products_on_product_id"
  end

  create_table "parts", charset: "utf8", force: :cascade do |t|
    t.string "part_number"
    t.string "description"
    t.string "photo_file_name"
    t.integer "photo_file_size"
    t.string "photo_content_type"
    t.datetime "photo_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "parent_id"
    t.index ["parent_id"], name: "index_parts_on_parent_id"
  end

  create_table "pricing_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.integer "pricelist_order"
    t.string "calculation_method"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "us"
    t.boolean "intl"
    t.index ["brand_id"], name: "index_pricing_types_on_brand_id"
  end

  create_table "product_accessories", charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "accessory_product_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["accessory_product_id"], name: "index_product_accessories_on_accessory_product_id"
    t.index ["product_id"], name: "index_product_accessories_on_product_id"
  end

  create_table "product_attachments", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.boolean "primary_photo", default: false
    t.string "product_attachment_file_name"
    t.string "product_attachment_content_type"
    t.datetime "product_attachment_updated_at", precision: nil
    t.integer "product_attachment_file_size"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "product_media_file_name"
    t.string "product_media_content_type"
    t.integer "product_media_file_size"
    t.datetime "product_media_updated_at", precision: nil
    t.string "product_media_thumb_file_name"
    t.string "product_media_thumb_content_type"
    t.integer "product_media_thumb_file_size"
    t.datetime "product_media_thumb_updated_at", precision: nil
    t.bigint "width"
    t.bigint "height"
    t.boolean "no_lightbox"
    t.boolean "hide_from_product_page"
    t.text "product_attachment_meta"
    t.string "full_width_banner_url"
    t.boolean "show_as_full_width_banner", default: false
    t.index ["product_id", "primary_photo"], name: "index_product_attachments_on_product_id_and_primary_photo"
    t.index ["product_id"], name: "index_product_attachments_on_product_id"
  end

  create_table "product_audio_demos", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "audio_demo_id"
    t.integer "product_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["audio_demo_id"], name: "index_product_audio_demos_on_audio_demo_id"
    t.index ["product_id"], name: "index_product_audio_demos_on_product_id"
  end

  create_table "product_badges", charset: "utf8", force: :cascade do |t|
    t.integer "badge_id"
    t.integer "product_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["badge_id"], name: "index_product_badges_on_badge_id"
    t.index ["product_id"], name: "index_product_badges_on_product_id"
  end

  create_table "product_case_studies", charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "case_study_slug"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_study_slug"], name: "index_product_case_studies_on_case_study_slug"
    t.index ["product_id"], name: "index_product_case_studies_on_product_id"
  end

  create_table "product_descriptions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "content_name"
    t.text "content_part1"
    t.text "content_part2"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["content_name"], name: "index_product_descriptions_on_content_name"
    t.index ["product_id"], name: "index_product_descriptions_on_product_id"
  end

  create_table "product_documents", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "language"
    t.string "document_type"
    t.string "document_file_name"
    t.integer "document_file_size"
    t.datetime "document_updated_at", precision: nil
    t.string "document_content_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.string "name_override"
    t.integer "position"
    t.string "direct_upload_url"
    t.boolean "processed", default: false
    t.boolean "show_on_public_site", default: true
    t.datetime "link_checked_at", precision: nil
    t.string "link_status"
    t.index ["cached_slug"], name: "index_product_documents_on_cached_slug", unique: true
    t.index ["product_id"], name: "index_product_documents_on_product_id"
  end

  create_table "product_effects", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "effect_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["effect_id"], name: "index_product_effects_on_effect_id"
    t.index ["product_id"], name: "index_product_effects_on_product_id"
  end

  create_table "product_families", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "family_photo_file_name"
    t.string "family_photo_content_type"
    t.datetime "family_photo_updated_at", precision: nil
    t.integer "family_photo_file_size"
    t.text "intro"
    t.integer "brand_id"
    t.text "keywords"
    t.integer "position"
    t.integer "parent_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "hide_from_navigation", default: false
    t.string "cached_slug"
    t.string "background_image_file_name"
    t.integer "background_image_file_size"
    t.string "background_image_content_type"
    t.datetime "background_image_updated_at", precision: nil
    t.string "background_color"
    t.string "layout_class"
    t.string "family_banner_file_name"
    t.string "family_banner_content_type"
    t.integer "family_banner_file_size"
    t.datetime "family_banner_updated_at", precision: nil
    t.string "title_banner_file_name"
    t.string "title_banner_content_type"
    t.integer "title_banner_file_size"
    t.datetime "title_banner_updated_at", precision: nil
    t.text "post_content"
    t.text "short_description"
    t.string "preview_password"
    t.string "preview_username"
    t.integer "product_family_products_count"
    t.string "old_url"
    t.boolean "has_full_width_features", default: false
    t.string "product_selector_behavior"
    t.text "meta_description"
    t.integer "featured_product_id"
    t.integer "warranty_period"
    t.boolean "group_on_custom_shop", default: false
    t.text "accessories_content", size: :medium
    t.text "before_product_content", size: :medium
    t.integer "locale_product_families_count"
    t.string "product_nav_separator"
    t.string "title"
    t.text "custom_css"
    t.integer "geo_parent_id"
    t.index ["brand_id"], name: "index_product_families_on_brand_id"
    t.index ["cached_slug"], name: "index_product_families_on_cached_slug", unique: true
    t.index ["geo_parent_id"], name: "index_product_families_on_geo_parent_id"
    t.index ["parent_id"], name: "index_product_families_on_parent_id"
  end

  create_table "product_family_case_studies", charset: "utf8", force: :cascade do |t|
    t.integer "product_family_id"
    t.string "case_study_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_family_id"], name: "index_product_family_case_studies_on_product_family_id"
  end

  create_table "product_family_customizable_attributes", charset: "utf8", force: :cascade do |t|
    t.integer "product_family_id"
    t.integer "customizable_attribute_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_family_product_filters", charset: "utf8", force: :cascade do |t|
    t.integer "product_family_id"
    t.integer "product_filter_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_family_id"], name: "index_product_family_product_filters_on_product_family_id"
    t.index ["product_filter_id"], name: "index_product_family_product_filters_on_product_filter_id"
  end

  create_table "product_family_products", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "product_family_id"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["product_family_id"], name: "index_product_family_products_on_product_family_id"
    t.index ["product_id"], name: "index_product_family_products_on_product_id"
  end

  create_table "product_family_testimonials", charset: "utf8", force: :cascade do |t|
    t.integer "product_family_id"
    t.integer "testimonial_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_family_id"], name: "index_product_family_testimonials_on_product_family_id"
    t.index ["testimonial_id"], name: "index_product_family_testimonials_on_testimonial_id"
  end

  create_table "product_family_videos", charset: "utf8", force: :cascade do |t|
    t.integer "product_family_id"
    t.string "youtube_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "description"
    t.integer "duration_seconds"
    t.date "published_on"
    t.index ["product_family_id"], name: "index_product_family_videos_on_product_family_id"
  end

  create_table "product_filters", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "value_type"
    t.string "min_value"
    t.string "max_value"
    t.string "uom"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "secondary_uom"
    t.string "secondary_uom_formula"
    t.integer "stepsize", default: 1
  end

  create_table "product_part_group_parts", charset: "utf8", force: :cascade do |t|
    t.integer "product_part_group_id"
    t.integer "part_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["part_id"], name: "index_product_part_group_parts_on_part_id"
    t.index ["product_part_group_id"], name: "index_product_part_group_parts_on_product_part_group_id"
  end

  create_table "product_part_groups", charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["parent_id"], name: "index_product_part_groups_on_parent_id"
    t.index ["product_id"], name: "index_product_part_groups_on_product_id"
  end

  create_table "product_parts", charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "part_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "parent_part_id"
    t.integer "parent_id"
    t.index ["parent_id"], name: "index_product_parts_on_parent_id"
    t.index ["parent_part_id"], name: "index_product_parts_on_parent_part_id"
    t.index ["part_id"], name: "index_product_parts_on_part_id"
    t.index ["product_id"], name: "index_product_parts_on_product_id"
  end

  create_table "product_prices", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "product_id"
    t.integer "pricing_type_id"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["pricing_type_id"], name: "index_product_prices_on_pricing_type_id"
    t.index ["product_id"], name: "index_product_prices_on_product_id"
  end

  create_table "product_product_filter_values", charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "product_filter_id"
    t.string "string_value"
    t.boolean "boolean_value"
    t.float "number_value"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_filter_id"], name: "index_product_product_filter_values_on_product_filter_id"
    t.index ["product_id"], name: "index_product_product_filter_values_on_product_id"
  end

  create_table "product_promotions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "promotion_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.float "discount"
    t.string "discount_type"
    t.index ["product_id"], name: "index_product_promotions_on_product_id"
    t.index ["promotion_id"], name: "index_product_promotions_on_promotion_id"
  end

  create_table "product_review_products", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "product_review_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["product_id"], name: "index_product_review_products_on_product_id"
    t.index ["product_review_id"], name: "index_product_review_products_on_product_review_id"
  end

  create_table "product_reviews", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.string "external_link"
    t.text "body"
    t.string "review_file_name"
    t.integer "review_file_size"
    t.string "review_content_type"
    t.datetime "review_updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.datetime "link_checked_at", precision: nil
    t.string "link_status", default: "200"
    t.string "cover_image_file_name"
    t.string "cover_image_content_type"
    t.integer "cover_image_file_size"
    t.datetime "cover_image_updated_at", precision: nil
    t.index ["cached_slug"], name: "index_product_reviews_on_cached_slug", unique: true
  end

  create_table "product_site_elements", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "product_id"
    t.integer "site_element_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "position"
    t.index ["product_id"], name: "index_product_site_elements_on_product_id"
    t.index ["site_element_id"], name: "index_product_site_elements_on_site_element_id"
  end

  create_table "product_softwares", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "software_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "product_position"
    t.integer "software_position"
    t.index ["product_id"], name: "index_product_softwares_on_product_id"
    t.index ["software_id"], name: "index_product_softwares_on_software_id"
  end

  create_table "product_solutions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "solution_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_product_solutions_on_product_id"
    t.index ["solution_id"], name: "index_product_solutions_on_solution_id"
  end

  create_table "product_specifications", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "specification_id"
    t.text "value"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["product_id"], name: "index_product_specifications_on_product_id"
    t.index ["specification_id"], name: "index_product_specifications_on_specification_id"
  end

  create_table "product_statuses", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "show_on_website", default: false
    t.boolean "discontinued", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "shipping", default: false
    t.boolean "eol", default: false
    t.integer "position"
  end

  create_table "product_suggestions", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "product_id"
    t.integer "suggested_product_id"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "product_training_classes", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "product_id"
    t.integer "training_class_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "product_training_modules", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "product_id"
    t.integer "training_module_id"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "product_videos", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "youtube_id"
    t.string "group"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title"
    t.string "description"
    t.integer "duration_seconds"
    t.date "published_on"
    t.index ["product_id"], name: "index_product_videos_on_product_id"
  end

  create_table "products", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "sap_sku"
    t.text "short_description"
    t.text "keywords"
    t.integer "product_status_id"
    t.boolean "rohs", default: true
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.string "background_image_file_name"
    t.integer "background_image_file_size"
    t.string "background_image_content_type"
    t.datetime "background_image_updated_at", precision: nil
    t.string "background_color"
    t.string "password"
    t.text "previewers"
    t.boolean "has_pedals", default: false
    t.integer "brand_id"
    t.integer "warranty_period"
    t.string "layout_class"
    t.string "direct_buy_link"
    t.string "features_tab_name"
    t.string "demo_link"
    t.boolean "hide_buy_it_now_button"
    t.string "more_info_url"
    t.integer "parent_products_count", default: 0, null: false
    t.string "short_description_1"
    t.string "short_description_2"
    t.string "short_description_3"
    t.string "short_description_4"
    t.string "stock_status"
    t.date "available_on"
    t.integer "stock_level"
    t.integer "harman_employee_price_cents"
    t.string "harman_employee_price_currency", default: "USD", null: false
    t.integer "street_price_cents"
    t.string "street_price_currency", default: "USD", null: false
    t.integer "msrp_cents"
    t.string "msrp_currency", default: "USD", null: false
    t.integer "sale_price_cents"
    t.string "sale_price_currency", default: "USD", null: false
    t.integer "cost_cents"
    t.string "cost_currency", default: "USD", null: false
    t.text "alert"
    t.boolean "show_alert", default: false
    t.string "extended_description_tab_name"
    t.string "product_page_url"
    t.text "legal_disclaimer"
    t.boolean "show_recommended_verticals", default: true
    t.boolean "enterprise", default: false
    t.boolean "entertainment", default: false
    t.text "registration_notice"
    t.string "photometric_id"
    t.text "hidden_content"
    t.string "old_url"
    t.string "hidden_locales"
    t.text "meta_description"
    t.boolean "hide_contact_buttons"
    t.string "firmware_name"
    t.boolean "collapse_content", default: false
    t.integer "geo_parent_id"
    t.string "highlight_format"
    t.boolean "hide_product_photo", default: false
    t.text "custom_css"
    t.string "training_url"
    t.index ["brand_id", "product_status_id"], name: "index_products_on_brand_id_and_product_status_id"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["cached_slug"], name: "index_products_on_cached_slug", unique: true
    t.index ["geo_parent_id"], name: "index_products_on_geo_parent_id"
  end

  create_table "promotions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.date "show_start_on"
    t.date "show_end_on"
    t.date "start_on"
    t.date "end_on"
    t.text "description"
    t.string "promo_form_file_name"
    t.integer "promo_form_file_size"
    t.datetime "promo_form_updated_at", precision: nil
    t.string "promo_form_content_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.string "tile_file_name"
    t.integer "tile_file_size"
    t.string "tile_content_type"
    t.datetime "tile_updated_at", precision: nil
    t.string "post_registration_subject"
    t.text "post_registration_message"
    t.boolean "send_post_registration_message", default: false
    t.integer "brand_id"
    t.text "toolkit_instructions"
    t.string "homepage_banner_file_name"
    t.string "homepage_banner_content_type"
    t.integer "homepage_banner_file_size"
    t.datetime "homepage_banner_updated_at", precision: nil
    t.string "homepage_headline"
    t.text "homepage_text"
    t.float "discount"
    t.string "discount_type"
    t.boolean "show_recalculated_price"
    t.integer "banner_id"
    t.index ["brand_id"], name: "index_promotions_on_brand_id"
    t.index ["cached_slug"], name: "index_promotions_on_cached_slug", unique: true
  end

  create_table "registered_downloads", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.string "protected_software_file_name"
    t.integer "protected_software_file_size"
    t.string "protected_software_content_type"
    t.datetime "protected_software_updated_at", precision: nil
    t.integer "download_count"
    t.text "html_template"
    t.text "intro_page_content"
    t.text "confirmation_page_content"
    t.text "email_template"
    t.text "download_page_content"
    t.string "url"
    t.string "valid_code"
    t.integer "per_download_limit"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "from_email"
    t.string "subject"
    t.boolean "require_serial_number"
    t.string "cc"
    t.text "products"
    t.boolean "require_employee_number"
    t.boolean "require_store_number"
    t.boolean "require_manager_name"
    t.boolean "send_coupon_code"
    t.text "coupon_codes"
    t.boolean "require_receipt"
    t.boolean "auto_deliver"
    t.index ["brand_id"], name: "index_registered_downloads_on_brand_id"
  end

  create_table "sales_region_countries", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "sales_region_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["sales_region_id"], name: "index_sales_region_countries_on_sales_region_id"
  end

  create_table "sales_regions", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.string "support_email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["brand_id"], name: "index_sales_regions_on_brand_id"
  end

  create_table "scheduled_task_actions", charset: "utf8", force: :cascade do |t|
    t.integer "scheduled_task_id"
    t.string "field_name"
    t.string "field_type"
    t.integer "new_integer_value"
    t.string "new_string_value"
    t.text "new_text_value"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "new_boolean_value"
    t.date "new_date_value"
    t.datetime "new_datetime_value", precision: nil
    t.index ["scheduled_task_id"], name: "index_scheduled_task_actions_on_scheduled_task_id"
  end

  create_table "scheduled_task_logs", charset: "utf8", force: :cascade do |t|
    t.integer "scheduled_task_id"
    t.integer "scheduled_task_action_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scheduled_task_action_id"], name: "index_scheduled_task_logs_on_scheduled_task_action_id"
    t.index ["scheduled_task_id"], name: "index_scheduled_task_logs_on_scheduled_task_id"
  end

  create_table "scheduled_tasks", charset: "utf8", force: :cascade do |t|
    t.datetime "perform_at", precision: nil
    t.string "schedulable_type"
    t.bigint "schedulable_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedulable_type", "schedulable_id"], name: "index_scheduled_tasks_on_schedulable"
  end

  create_table "service_centers", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "name2", limit: 100
    t.string "name3", limit: 100
    t.string "name4", limit: 100
    t.string "address", limit: 100
    t.string "city", limit: 100
    t.string "state", limit: 50
    t.string "zip", limit: 40
    t.string "telephone", limit: 40
    t.string "fax", limit: 40
    t.string "email", limit: 100
    t.string "account_number", limit: 50
    t.string "website", limit: 100
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lng", precision: 15, scale: 10
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "brand_id"
    t.boolean "vintage"
    t.index ["brand_id"], name: "index_service_centers_on_brand_id"
  end

  create_table "settings", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "setting_type"
    t.string "string_value"
    t.integer "integer_value"
    t.text "text_value"
    t.string "slide_file_name"
    t.integer "slide_file_size"
    t.string "locale"
    t.integer "brand_id"
    t.string "slide_content_type"
    t.datetime "slide_updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "start_on"
    t.date "remove_on"
    t.text "description"
    t.index ["brand_id", "name", "locale"], name: "index_settings_on_brand_id_and_name_and_locale"
    t.index ["brand_id", "name"], name: "index_settings_on_brand_id_and_name"
    t.index ["brand_id"], name: "index_settings_on_brand_id"
  end

  create_table "signups", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "campaign"
    t.integer "brand_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "synced_on"
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.index ["brand_id"], name: "index_signups_on_brand_id"
  end

  create_table "site_element_attachments", charset: "utf8", force: :cascade do |t|
    t.integer "site_element_id"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["site_element_id"], name: "index_site_element_attachments_on_site_element_id"
  end

  create_table "site_elements", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.string "resource_file_name"
    t.integer "resource_file_size"
    t.string "resource_content_type"
    t.datetime "resource_updated_at", precision: nil
    t.string "resource_type"
    t.boolean "show_on_public_site"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "executable_file_name"
    t.string "executable_content_type"
    t.integer "executable_file_size"
    t.datetime "executable_updated_at", precision: nil
    t.string "cached_slug"
    t.string "external_url"
    t.boolean "is_document"
    t.boolean "is_software"
    t.string "direct_upload_url"
    t.boolean "processed", default: false
    t.string "version"
    t.string "language"
    t.integer "access_level_id"
    t.text "content"
    t.string "source"
    t.datetime "link_checked_at", precision: nil
    t.string "link_status"
    t.integer "current_version_id"
    t.index ["access_level_id"], name: "index_site_elements_on_access_level_id"
    t.index ["brand_id"], name: "index_site_elements_on_brand_id"
    t.index ["cached_slug"], name: "index_site_elements_on_cached_slug"
    t.index ["current_version_id"], name: "index_site_elements_on_current_version_id"
  end

  create_table "software_activations", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "software_id"
    t.string "challenge"
    t.string "activation_key"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "software_attachments", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "software_id"
    t.string "software_attachment_file_name"
    t.integer "software_attachment_file_size"
    t.string "software_attachment_content_type"
    t.datetime "software_attachment_updated_at", precision: nil
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "software_operating_systems", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "software_id"
    t.integer "operating_system_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["operating_system_id"], name: "index_software_operating_systems_on_operating_system_id"
    t.index ["software_id"], name: "index_software_operating_systems_on_software_id"
  end

  create_table "software_report_subscriptions", charset: "utf8", force: :cascade do |t|
    t.integer "software_report_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["software_report_id"], name: "index_software_report_subscriptions_on_software_report_id"
    t.index ["user_id"], name: "index_software_report_subscriptions_on_user_id"
  end

  create_table "software_reports", charset: "utf8", force: :cascade do |t|
    t.integer "software_id"
    t.integer "previous_count"
    t.date "previous_count_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "software_training_classes", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "software_id"
    t.integer "training_class_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "software_training_modules", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "software_id"
    t.integer "training_module_id"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "softwares", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "ware_file_name"
    t.bigint "ware_file_size"
    t.string "ware_content_type"
    t.datetime "ware_updated_at", precision: nil
    t.integer "download_count"
    t.string "version"
    t.text "description"
    t.string "platform"
    t.boolean "active"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "category"
    t.string "cached_slug"
    t.integer "brand_id"
    t.string "link"
    t.text "multipliers"
    t.string "activation_name"
    t.datetime "link_checked_at", precision: nil
    t.string "link_status", default: "200"
    t.string "layout_class"
    t.integer "current_version_id"
    t.string "bit"
    t.boolean "active_without_products"
    t.string "direct_upload_url"
    t.boolean "processed", default: false
    t.text "alert"
    t.boolean "show_alert", default: false
    t.text "side_content"
    t.index ["brand_id"], name: "index_softwares_on_brand_id"
    t.index ["cached_slug"], name: "index_softwares_on_cached_slug", unique: true
  end

  create_table "solutions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "cached_slug"
    t.string "vertical_market_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "content"
    t.string "product_header"
    t.index ["cached_slug"], name: "index_solutions_on_cached_slug", unique: true
  end

  create_table "specification_groups", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "specifications", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "cached_slug"
    t.integer "specification_group_id"
    t.integer "position"
    t.index ["cached_slug"], name: "index_specifications_on_cached_slug", unique: true
    t.index ["specification_group_id"], name: "index_specifications_on_specification_group_id"
  end

  create_table "support_subjects", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "brand_id"
    t.string "name"
    t.string "recipient"
    t.integer "position"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "locale"
    t.index ["brand_id"], name: "index_support_subjects_on_brand_id"
    t.index ["locale"], name: "index_support_subjects_on_locale"
  end

  create_table "system_components", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "system_id"
    t.integer "product_id"
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["system_id"], name: "index_system_components_on_system_id"
  end

  create_table "system_configuration_components", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_configuration_id"
    t.integer "system_component_id"
    t.integer "quantity"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["system_configuration_id"], name: "index_system_configuration_components_on_system_configuration_id"
  end

  create_table "system_configuration_option_values", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_configuration_option_id"
    t.integer "system_option_value_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["system_configuration_option_id"], name: "s_c_o_v_s_c_o_id"
  end

  create_table "system_configuration_options", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_configuration_id"
    t.integer "system_option_id"
    t.integer "system_option_value_id"
    t.string "direct_value"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["system_configuration_id"], name: "index_system_configuration_options_on_system_configuration_id"
  end

  create_table "system_configurations", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_id"
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "project_name"
    t.string "email"
    t.string "phone"
    t.string "company"
    t.string "preferred_contact_method"
    t.string "access_hash"
  end

  create_table "system_option_values", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_option_id"
    t.string "name"
    t.integer "position"
    t.text "description"
    t.boolean "default", default: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "send_mail_to"
    t.index ["system_option_id"], name: "index_system_option_values_on_system_option_id"
  end

  create_table "system_options", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_id"
    t.string "name"
    t.string "option_type"
    t.integer "position"
    t.integer "parent_id"
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "long_description"
    t.string "default_value"
    t.boolean "show_on_first_screen", default: false
    t.index ["parent_id"], name: "index_system_options_on_parent_id"
    t.index ["system_id"], name: "index_system_options_on_system_id"
  end

  create_table "system_rule_actions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_rule_id"
    t.string "action_type"
    t.integer "system_option_id"
    t.integer "system_option_value_id"
    t.text "alert"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "system_component_id"
    t.integer "quantity"
    t.string "ratio"
    t.index ["system_rule_id"], name: "index_system_rule_actions_on_system_rule_id"
  end

  create_table "system_rule_condition_groups", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_rule_id"
    t.string "logic_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["system_rule_id"], name: "index_system_rule_condition_groups_on_system_rule_id"
  end

  create_table "system_rule_conditions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_rule_condition_group_id"
    t.integer "system_option_id"
    t.string "operator"
    t.integer "system_option_value_id"
    t.string "direct_value"
    t.string "logic_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["system_rule_condition_group_id"], name: "index_system_rule_conditions_on_system_rule_condition_group_id"
  end

  create_table "system_rules", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "system_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "enabled", default: true
    t.boolean "perform_opposite", default: true
    t.index ["system_id"], name: "index_system_rules_on_system_id"
  end

  create_table "systems", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "send_mail_to"
    t.text "contact_me_intro"
    t.index ["brand_id"], name: "index_systems_on_brand_id"
  end

  create_table "taggings", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "testimonials", charset: "utf8", force: :cascade do |t|
    t.integer "brand_id"
    t.string "title"
    t.string "subtitle"
    t.text "summary"
    t.text "content"
    t.string "banner_file_name"
    t.string "banner_content_type"
    t.integer "banner_file_size"
    t.datetime "banner_updated_at", precision: nil
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "cached_slug"
    t.index ["brand_id"], name: "index_testimonials_on_brand_id"
    t.index ["cached_slug"], name: "index_testimonials_on_cached_slug"
  end

  create_table "training_class_registrations", charset: "utf8", force: :cascade do |t|
    t.integer "training_class_id"
    t.string "name"
    t.string "email"
    t.text "comments"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["training_class_id"], name: "index_training_class_registrations_on_training_class_id"
  end

  create_table "training_classes", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.datetime "start_at", precision: nil
    t.datetime "end_at", precision: nil
    t.string "language"
    t.integer "instructor_id"
    t.string "more_info_url"
    t.string "location"
    t.boolean "filled"
    t.boolean "canceled"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "training_course_id"
    t.string "registration_url"
    t.index ["training_course_id"], name: "index_training_classes_on_training_course_id"
  end

  create_table "training_courses", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.text "description"
    t.string "cached_slug"
    t.string "send_registrations_to"
    t.string "image_file_name"
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.string "image_content_type"
    t.text "short_description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "more_info_url"
    t.index ["brand_id"], name: "index_training_courses_on_brand_id"
    t.index ["cached_slug"], name: "index_training_courses_on_cached_slug"
  end

  create_table "training_modules", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.string "training_module_file_name"
    t.string "training_module_content_type"
    t.integer "training_module_file_size"
    t.datetime "training_module_updated_at", precision: nil
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "width"
    t.integer "height"
    t.index ["brand_id"], name: "index_training_modules_on_brand_id"
  end

  create_table "us_regions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "cached_slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["cached_slug"], name: "index_us_regions_on_cached_slug"
  end

  create_table "us_rep_regions", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "us_rep_id"
    t.integer "us_region_id"
    t.integer "brand_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["brand_id", "us_region_id"], name: "index_us_rep_regions_on_brand_id_and_us_region_id"
    t.index ["brand_id"], name: "index_us_rep_regions_on_brand_id"
  end

  create_table "us_reps", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "contact"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.string "cached_slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "contacts"
    t.index ["cached_slug"], name: "index_us_reps_on_cached_slug"
  end

  create_table "users", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "admin"
    t.boolean "customer_service"
    t.boolean "online_retailer"
    t.boolean "translator"
    t.boolean "rohs"
    t.boolean "market_manager"
    t.boolean "artist_relations"
    t.boolean "engineer"
    t.boolean "clinician"
    t.boolean "rep"
    t.string "name"
    t.boolean "rso"
    t.boolean "sales_admin"
    t.boolean "dealer"
    t.boolean "distributor"
    t.boolean "marketing_staff"
    t.string "phone_number"
    t.string "job_description"
    t.string "job_title"
    t.string "profile_image_file_name"
    t.string "profile_image_content_type"
    t.integer "profile_image_file_size"
    t.datetime "profile_image_updated_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.boolean "employee"
    t.boolean "media"
    t.boolean "queue_admin"
    t.string "profile_pic_file_name"
    t.integer "profile_pic_file_size"
    t.string "profile_pic_content_type"
    t.datetime "profile_pic_updated_at", precision: nil
    t.boolean "project_manager"
    t.boolean "executive"
    t.string "account_number"
    t.string "locales"
    t.boolean "technician"
    t.boolean "super_technician", default: false
    t.string "last_host"
    t.boolean "vip_programmers_admin", default: false
    t.boolean "jbl_vertec_vtx_owner_approver", default: false
    t.boolean "customer"
    t.boolean "custom_shop_admin", default: false
    t.index ["account_number"], name: "index_users_on_account_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vip_certifications", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_emails", charset: "utf8", force: :cascade do |t|
    t.string "label"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_global_regions", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_location_global_regions", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_location_id"
    t.bigint "vip_global_region_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_global_region_id"], name: "index_vip_location_global_regions_on_vip_global_region_id"
    t.index ["vip_location_id"], name: "index_vip_location_global_regions_on_vip_location_id"
  end

  create_table "vip_location_service_areas", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_location_id"
    t.bigint "vip_service_area_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_location_id"], name: "index_vip_location_service_areas_on_vip_location_id"
    t.index ["vip_service_area_id"], name: "index_vip_location_service_areas_on_vip_service_area_id"
  end

  create_table "vip_locations", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_markets", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_phones", charset: "utf8", force: :cascade do |t|
    t.string "label"
    t.string "phone"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_programmer_certifications", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_certification_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_certification_id"], name: "index_vip_programmer_certifications_on_vip_certification_id"
    t.index ["vip_programmer_id"], name: "index_vip_programmer_certifications_on_vip_programmer_id"
  end

  create_table "vip_programmer_emails", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_email_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_email_id"], name: "index_vip_programmer_emails_on_vip_email_id"
    t.index ["vip_programmer_id"], name: "index_vip_programmer_emails_on_vip_programmer_id"
  end

  create_table "vip_programmer_locations", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_location_id"], name: "index_vip_programmer_locations_on_vip_location_id"
    t.index ["vip_programmer_id"], name: "index_vip_programmer_locations_on_vip_programmer_id"
  end

  create_table "vip_programmer_markets", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_market_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_market_id"], name: "index_vip_programmer_markets_on_vip_market_id"
    t.index ["vip_programmer_id"], name: "index_vip_programmer_markets_on_vip_programmer_id"
  end

  create_table "vip_programmer_phones", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_phone_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_phone_id"], name: "index_vip_programmer_phones_on_vip_phone_id"
    t.index ["vip_programmer_id"], name: "index_vip_programmer_phones_on_vip_programmer_id"
  end

  create_table "vip_programmer_services", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_service_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_programmer_id"], name: "index_vip_programmer_services_on_vip_programmer_id"
    t.index ["vip_service_id"], name: "index_vip_programmer_services_on_vip_service_id"
  end

  create_table "vip_programmer_site_elements", charset: "utf8", force: :cascade do |t|
    t.bigint "vip_programmer_id"
    t.bigint "site_element_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_programmer_id"], name: "index_vip_programmer_site_elements_on_vip_programmer_id"
  end

  create_table "vip_programmer_skills", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_skill_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_programmer_id"], name: "index_vip_programmer_skills_on_vip_programmer_id"
    t.index ["vip_skill_id"], name: "index_vip_programmer_skills_on_vip_skill_id"
  end

  create_table "vip_programmer_trainings", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_training_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_programmer_id"], name: "index_vip_programmer_trainings_on_vip_programmer_id"
    t.index ["vip_training_id"], name: "index_vip_programmer_trainings_on_vip_training_id"
  end

  create_table "vip_programmer_websites", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_programmer_id"
    t.bigint "vip_website_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_programmer_id"], name: "index_vip_programmer_websites_on_vip_programmer_id"
    t.index ["vip_website_id"], name: "index_vip_programmer_websites_on_vip_website_id"
  end

  create_table "vip_programmers", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "examples"
    t.string "security_clearance"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_service_areas", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_service_categories", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_service_service_categories", charset: "utf8", force: :cascade do |t|
    t.integer "position"
    t.bigint "vip_service_id"
    t.bigint "vip_service_category_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["vip_service_category_id"], name: "index_vip_service_service_categories_on_vip_service_category_id"
    t.index ["vip_service_id"], name: "index_vip_service_service_categories_on_vip_service_id"
  end

  create_table "vip_services", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_skills", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_trainings", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "vip_websites", charset: "utf8", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "warranty_registrations", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title", limit: 10
    t.string "first_name", limit: 100
    t.string "last_name", limit: 100
    t.string "middle_initial", limit: 4
    t.string "company", limit: 100
    t.string "jobtitle", limit: 100
    t.string "country", limit: 100
    t.string "email", limit: 100
    t.boolean "subscribe", default: false
    t.integer "brand_id"
    t.integer "product_id"
    t.string "serial_number", limit: 100
    t.date "registered_on"
    t.date "purchased_on"
    t.string "purchased_from", limit: 100
    t.string "purchase_country", limit: 100
    t.string "purchase_price", limit: 100
    t.text "comments"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "exported", default: false
    t.datetime "synced_on", precision: nil
    t.index ["brand_id"], name: "index_warranty_registrations_on_brand_id"
    t.index ["exported"], name: "index_warranty_registrations_on_exported"
  end

  create_table "website_locales", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "website_id"
    t.string "locale"
    t.boolean "complete", default: false
    t.boolean "default", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["locale", "website_id"], name: "index_website_locales_on_locale_and_website_id"
  end

  create_table "websites", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "url"
    t.integer "brand_id"
    t.string "folder"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "comment"
    t.string "default_locale"
    t.index ["brand_id"], name: "index_websites_on_brand_id"
    t.index ["url"], name: "index_websites_on_url", unique: true
  end

  add_foreign_key "amx_dxlink_combo_attributes", "amx_dxlink_attribute_names"
  add_foreign_key "amx_dxlink_combo_attributes", "amx_dxlink_combos"
  add_foreign_key "amx_dxlink_combos", "amx_dxlink_device_infos", column: "rx_id"
  add_foreign_key "amx_dxlink_combos", "amx_dxlink_device_infos", column: "tx_id"
  add_foreign_key "banner_locales", "banners"
  add_foreign_key "manufacturer_partners", "site_elements"
  add_foreign_key "vip_location_global_regions", "vip_global_regions"
  add_foreign_key "vip_location_global_regions", "vip_locations"
  add_foreign_key "vip_location_service_areas", "vip_locations"
  add_foreign_key "vip_location_service_areas", "vip_service_areas"
  add_foreign_key "vip_programmer_certifications", "vip_certifications"
  add_foreign_key "vip_programmer_certifications", "vip_programmers"
  add_foreign_key "vip_programmer_emails", "vip_emails"
  add_foreign_key "vip_programmer_emails", "vip_programmers"
  add_foreign_key "vip_programmer_locations", "vip_locations"
  add_foreign_key "vip_programmer_locations", "vip_programmers"
  add_foreign_key "vip_programmer_markets", "vip_markets"
  add_foreign_key "vip_programmer_markets", "vip_programmers"
  add_foreign_key "vip_programmer_phones", "vip_phones"
  add_foreign_key "vip_programmer_phones", "vip_programmers"
  add_foreign_key "vip_programmer_services", "vip_programmers"
  add_foreign_key "vip_programmer_services", "vip_services"
  add_foreign_key "vip_programmer_site_elements", "vip_programmers"
  add_foreign_key "vip_programmer_skills", "vip_programmers"
  add_foreign_key "vip_programmer_skills", "vip_skills"
  add_foreign_key "vip_programmer_trainings", "vip_programmers"
  add_foreign_key "vip_programmer_trainings", "vip_trainings"
  add_foreign_key "vip_programmer_websites", "vip_programmers"
  add_foreign_key "vip_programmer_websites", "vip_websites"
  add_foreign_key "vip_service_service_categories", "vip_service_categories"
  add_foreign_key "vip_service_service_categories", "vip_services"
end
