require "domain_conditions"

HarmanSignalProcessingWebsite::Application.routes.draw do

  get '/session_info' => "main#session_info", defaults: { format: 'txt' }
  get '/nodetest' => "node_test#index"
  get "robots" => "main#robots", defaults: { format: 'txt' }
  get "analytics" => "main#analytics", defaults: { format: 'txt' }
  get "signups/new"
  get "signups/more_info"
  get "signup/complete" => "signups#complete", as: :signup_complete

  get "warranty" => "support#warranty_policy"
  get "register" => "support#warranty_registration"

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :brands, only: [:index, :show] do
        collection { get :for_employee_store }
        member { get :service_centers }
      end
      resources :product_families, :products
      get '/brand_features/:id' => 'products#features', as: :brand_features
    end
    namespace :v2 do
      resources :brands, only: [:index, :show] do
        resources :softwares, as: :software, only: [:index, :show]
        resources :products, only: [:index, :show]
        resources :product_families, only: [:index, :show] do
          member { get :wave, defaults: { format: :xls } }
          collection { get :wave, defaults: { format: :xls } }
        end
        resources :pdfs, only: [:index]
      end
      resources :products, only: :show # for backwards compat
    end
  end

  # debugging help
  get "/site_info" => 'main#site_info'
  get '/resource/:id' => "site_elements#show", as: :site_resource

  devise_for :artists, controllers: { registrations: "artist_registrations" }
  devise_scope :artists do
    get 'artists', to: 'artists#index', as: :artist_root
  end

  match '/activate(/:software_name(/:challenge))' => 'softwares#activate', as: :software_activation, via: :all

  match '/:registered_download_url/register(/:code)' => 'registered_downloads#register', as: :register_to_download, via: :all
  match '/:registered_download_url/confirm' => 'registered_downloads#confirmation', as: :confirm_download_registration, via: :all
  match '/:registered_download_url/get_it/:download_code' => 'registered_downloads#show', as: :registered_download, via: :all
  match '/:registered_download_url/downloadr/:download_code' => 'registered_downloads#download', as: :registered_download_file, via: :all

  get '/favicon.ico' => 'main#favicon'
  get '/dashboard' => 'admin#index', as: :dashboard
  get "/admin" => "admin#index", as: :admin_root, locale: I18n.default_locale
  get 'sitemap(.:format)' => 'sitemap#index', as: :sitemap, defaults: { format: :xml }

  match "/create_pdf" => "pdfs#create", via: [:get, :post]

  # An example of a custom top-level landing page route:
  # match "/switchyourthinking" => "pages#show", custom_route: "switchyourthinking", locale: I18n.default_locale

  # These are only needed for site-specific routing (where you don't want a particular URL
  # to work on the other sites)

  constraints(AmxDomain) do
    match "/create_xml" => "amx_configurators#send_xml_file", via: [:get, :post], defaults: { format: :xml }
  end

  constraints(BssDomain) do
    get '/network-audio' => 'pages#network_audio'
  end

  constraints(CrownDomain) do
    get '/trucktourgiveaway(.:format)' => 'signups#new', defaults: { campaign: "Crown-TruckTour-Flip-2015" }
    get '/network-audio' => 'pages#network_audio'
  end

  # The constraint { locale: /#{Locale.all_unique_locales.join('|')}/ } limits the locale
  # to those configured in the Locale model which is configured in the admin area and reverts
  # to AVAILABLE_LOCALES in config/initializers/i18n.rb in case of problems

  # Main routing
  root to: 'main#default_locale'
  scope "(:locale)", locale: /#{Locale.all_unique_locales.join('|')}/ do
    get '/contacts' => redirect("#{I18n.locale}/support")
    constraints(AmxDomain) do
      get '/partners' => 'manufacturer_partners#partners_home', as: :amx_partners_home
      get '/partners/inconcert' => 'manufacturer_partners#partners_inconcert', as: :amx_partners_inconcert
      get '/partners/featured' => 'manufacturer_partners#featured_partner', as: :amx_featured_partner
      get '/partners/featured/:partner_name' => 'manufacturer_partners#featured_partner', as: :amx_featured_partner_selected
      get '/partners/featured-list' => 'manufacturer_partners#featured_partners', as: :amx_featured_partner_list
      match "partners/interest" => "amx_partner_interest_form#create", as: :amx_partner_interest, via: [:get, :post]
      resources :vip_programmers, as: :vips, path: "vips", only: [:index, :show]

      match "support/amx_itg_new_module_request" => "module_requests#create", as: :amx_itg_new_module_request, via: [:get, :post]
      # match "support/amx_itg_new_module_request_upload" => "module_requests#upload", as: :amx_itg_new_module_request_upload, via: [:post]
      match "tool/dxlink" => "amx_dxlink_tool#index", as: :amx_dxlink_tool, via: [:get, :post]
    end  # constraints(AmxDomain) do

    constraints(BssDomain) do
      get 'bss-network-audio' => 'pages#network_audio'
      get 'network-audio' => 'pages#network_audio'
    end

    constraints(CrownDomain) do
      get 'network-audio' => 'pages#network_audio'
    end

    constraints(MartinDomain) do
      get 'safety-documents', to: redirect('support/safety')
      get 'upgrade-me-to-supertech-just-this-once' => "gated_support#super_tech_upgrade"
    end

    constraints(JblProDomain) do
      get 'vertec-vtx-owners' => "where_to_find#vertec_vtx_owners", as: :vertec_vtx_owners, defaults: { format: :xls }
      get 'prx-one-dealers' => "where_to_find#prx_one_dealers", as: :prx_one_dealers, defaults: { format: :xls }
      get 'eon-one-mk2-dealers' => "where_to_find#eon_one_mk2_dealers", as: :eon_one_mk2_dealers, defaults: { format: :xls }
      get 'eon700-series-dealers' => "where_to_find#eon700_series_dealers", as: :eon700_series_dealers, defaults: { format: :xls }
      get 'vertec-vtx-owners-signup' => "jbl_vertec_vtx_owners#new", as: :vertec_vtx_owners_signup_form
      match 'vertec-vtx-owners-signup' => "jbl_vertec_vtx_owners#create", as: :create_vertec_vtx_owners_signup, via: [:post]
      get 'vertec-vtx-owners-signup/thankyou' => "jbl_vertec_vtx_owners#thankyou", as: :vertec_vtx_owners_signup_thankyou, via: [:get]
      get 'download-partner-search-results' => "where_to_find#download_partner_search_results", as: :download_partner_search_results, defaults: { format: :xls }
    end

    devise_for :users, controllers: {
      passwords: 'users/passwords'
    }
    scope "/admin" do
      devise_scope :user do
        get 'admin', to: 'admin#index', as: :admin_user_root
      end
    end
    namespace :admin do
      get 'show_campaign/:id' => 'signups#show_campaign', as: 'show_campaign'
      get 'stats/multiple_charts_one_site', as: :stats_page
      get 'dealers/export' => 'dealers#export_dealer_list', as: :export_dealer_list, defaults: { format: :xls }
      resources :products do
        collection do
          get :rohs
          put :update_rohs
          get :harman_employee_pricing
          put :update_harman_employee_pricing
          get :artist_pricing
          get :solutions
          put :update_solutions
        end
        member do
          get :delete_background
          put :copy
        end
        resources :product_specifications do
          member do
            post :copy
          end
          collection do
            post :update_order
            post :bulk_update
          end
        end
        resources :product_filter_values
      end  #  resources :products do
      resources :product_families do
        collection { post :update_order }
        member do
          get :delete_background, :delete_family_photo, :delete_family_banner, :delete_title_banner, :copy_products
          put :copy
          post :copy_products
        end
      end
      resources :warranty_registrations do
        collection { put :search }
        member { put :resend_confirmation }
      end
      resources :artists do
        collection do
          post :update_order
        end
        member { post :reset_password }
      end
      resources :settings do
        collection do
          get :homepage
          post :update_slides_order
          post :update_banners_order
          post :update_features_order
          post :big_bottom_box
        end
        member do
          get :copy
          get :homepage_banner_sorting
        end
      end
      resources :effect_types, only: [:create] do
        collection { post :update_order }
      end
      resources :users do
        member do
          post :reset_password
          put :remove_role
        end
        collection do
          get :roles
        end
      end
      resources :download_registrations do
        member do
          get :reset_and_resend
        end
      end
      resources :registered_downloads do
        member do
          get :send_messages
        end
      end
      resources :product_specifications do
        member do
          post :copy
        end
        collection do
          post :update_order
        end
      end
      resources :market_segments, path: :markets do
        member do
          get :delete_banner_image
        end
        collection do
          post :update_order
        end
      end
      resources :product_prices do
        collection { put :update_all }
      end
      resources :news do
        member {
          get :delete_news_photo
          get :delete_square
        }
        resources :news_images
      end

      resources :module_requests
      resources :amx_partner_interest_form

      resources :jbl_vertec_vtx_owners do
        member do
          get :approve_and_create_dealer
        end
      end

      resources :support_subjects
      resources :get_started_pages do
        member do
          get :delete_image
        end
        resources :get_started_panels
      end
      resources :events do
        member do
          get :delete_image
        end
      end
      resources :solutions do
        resources :brand_solutions
        resources :brand_solution_featured_products
        resources :product_solutions
      end
      resources :brand_solution_featured_products, only: :index do
        collection { post :update_order }
      end

      resources :brand_dealer_rental_products do
        collection { post :update_order }
      end

      resources :specifications do
        member { patch :remove_from_group }
        collection {
          post :update_order
          get :report
        }
      end
      resources :specification_groups do
        member { post :add_specification }
        collection { post :update_order }
      end
      resources :site_elements do
        resources :site_element_attachments
        collection {
          post :upload
          get :broken
        }
        member { get :new_version }
      end
      resources :product_site_elements do
        collection { post :update_order }
      end
      resources :softwares do
        collection { post :upload }
        member { get :new_version }
      end

      resources :training_courses do
        resources :training_classes do
          resources :training_class_registrations
        end
      end

      resources :banners do
        resources :banner_locales
      end
      resources :banner_locales, only: :new do
        collection { post :update_order }
      end

      resources :vip_programmers,
        :vip_locations,
        :vip_global_regions,
        :vip_service_areas,
        :vip_location_global_regions,
        :vip_location_service_areas,
        :vip_certifications,
        :vip_trainings,
        :vip_services,
        :vip_skills,
        :vip_markets,
        :vip_websites,
        :vip_emails,
        :vip_phones,
        :vip_service_categories,
        :vip_service_service_categories

        resources :vip_programmer_certifications,
                  :vip_programmer_emails,
                  :vip_programmer_locations,
                  :vip_programmer_markets,
                  :vip_programmer_phones,
                  :vip_programmer_services,
                  :vip_programmer_skills,
                  :vip_programmer_trainings,
                  :vip_programmer_websites do
          collection { post :update_order }
        end

      resources :product_family_product_filters do
        collection {
          post :update_order
        }
      end

      resources :amx_dxlink_device_infos, :amx_dxlink_combo_attributes, :amx_dxlink_attribute_names
      resources :amx_dxlink_combos do
        resources :amx_dxlink_combo_attributes do
          collection do
            post :bulk_update
          end
        end
      end
      resources :amx_dxlink_attribute_names do
          collection { post :update_order }
      end

      resources :service_centers,
        :product_family_customizable_attributes,
        :brand_specification_for_comparisons,
        :market_segment_product_families,
        :customizable_attribute_values,
        :product_family_case_studies,
        :product_family_testimonials,
        :software_training_classes,
        :software_training_modules,
        :get_started_page_products,
        :product_training_modules,
        :product_training_classes,
        :product_review_products,
        :product_family_products,
        :locale_product_families,
        :customizable_attributes,
        :product_part_group_part,
        :sales_region_countries,
        :online_retailer_links,
        :online_retailer_users,
        :manufacturer_partners,
        :product_family_videos,
        :software_attachments,
        :product_accessories,
        :product_audio_demos,
        :product_suggestions,
        :product_attachments,
        :product_promotions,
        :product_part_group,
        :product_softwares,
        :product_documents,
        :locale_softwares,
        :contact_messages,
        :online_retailers,
        :training_modules,
        :product_effects,
        :website_locales,
        :product_reviews,
        :artist_products,
        :parent_products,
        :product_filters,
        :product_badges,
        :product_videos,
        :faq_categories,
        :us_rep_regions,
        :bad_actor_logs,
        :product_parts,
        :installations,
        :pricing_types,
        :news_products,
        :sales_regions,
        :distributors,
        :artist_tiers,
        :testimonials,
        :audio_demos,
        :promotions,
        :us_regions,
        :websites,
        :captchas,
        :features,
        :us_reps,
        :effects,
        :locales,
        :signups,
        :dealers,
        :badges,
        :brands,
        :pages,
        :parts,
        :faqs do
        collection { post :update_order }
        collection { post :upload }
      end

      resources :scheduled_tasks, shallow: true do
        member { get :run }
        resources :scheduled_task_actions
      end
      get "scheduled_tasks/:id/value_field/:field_name" => 'scheduled_tasks#value_field'

      get "utilities" => "utilities#index"
      put "utilities/flush_cache" => "utilities#flush_cache", as: :flush_cache

      #match "translations/:target_locale(/:action)" => "content_translations", as: :translations
      get 'content_translation/languages' => 'content_translations#languages', as: :content_translation_languages
      scope path: '/:target_locale', target_locale: /#{Locale.all_unique_locales.join('|')}/ do
        resources :content_translations do
          collection {get :list, :combined}
          collection {post :combined}
        end
      end

    end # end admin scope

    get 'teaser' => 'main#teaser'
    resources :signups, only: [:new, :create]
    get "signup" => "signups#new"
    get "signups" => "signups#new"
    get 'distributors/search_new' => 'distributors#index', as: :distributor_search_new
    resources :us_reps, :distributors, only: [:index, :show] do
      collection { get :search }
    end
    get 'us-reps' => 'us_reps#us_reps_json'
    resources :softwares, only: [:index, :show, :new, :edit] do
      member do
        get :download
        get :new_version
        get :increment_count
      end
    end
    resources :software_attachments, only: [:download] do
      member { get :download }
    end

    resources :news, only: [:index, :show, :update] do
      collection { get :archived }
      member { get :martin_redirect }
    end
    get "news/filter_by_tag/:tag" => 'news#filter_by_tag', as: :tag_filtered_news
    resources :solutions, only: [:index, :show]
    resources :faq_categories, only: [:index, :show]
    get "faqs" => 'faq_categories#index', as: :faqs
    resources :faqs, only: [:index, :show]
    get "product_faqs" => 'faqs#index', as: :product_faqs
    get "artists/become_an_artist" => 'artists#become', as: :become_an_artist
    get "artists/all(/:letter)" => 'artists#all', as: :all_artists
    resources :artists, only: [:index, :show] do
      collection {
        get :list
        get :touring
      }
    end
    get 'training' => 'training#index', as: :training
    resources :training_modules, only: [:index, :show]
    resources :training_courses, only: [:show] do
      resources :training_classes, only: :show do
        resources :training_class_registrations
      end
    end
    resources :market_segments, path: :markets
    resources :pages,
      :installations,
      :product_reviews
    get "/market_segments/:id", to: redirect("/markets/%{id}")
    resources :promotions, only: [:index, :show, :new, :edit]
    resources :product_families, only: [:index, :show] do
      resources :testimonials, only: :index
      member do
        get 'safety-documents'
        get 'current-products-count', defaults: { format: 'js' }
      end
    end
    resources :testimonials, only: :show
    resources :products, only: [:index, :discontinued] do
      member do
        get :buy_it_now
        get :preview
        get :photometric
        get :bom
        post :bom
        put :preview
        get :compliance
      end
      collection do
        post :compare
        get :edit_warranty
        put :update_warranty
      end
      resources :product_attachments, only: :edit
    end
    get 'products/:id(/:tab)' => 'products#show', as: :product
    resources :product_documents, only: [:index, :show]
    resources :parts, only: [:index]
    resources :events, only: [:index, :show]
    resources :site_elements, only: [:show, :edit, :new] do
      member { get :new_version }
    end
    resources :product_specifications, only: :edit
    resources :leads, only: [:new, :create]

    get 'product_selector' => 'product_selector#index', as: :product_selector
    namespace :product_selector do
      resources :product_families, only: :show do
        member do
          get ':subfamily_id' => 'product_families#subfamily', as: :product_selector_subfamily
        end
      end
    end

    get 'get-started' => 'get_started#index', as: :get_started_index
    get 'get-started/:id' => 'get_started#show', as: :get_started
    get 'getting-started/:id' => 'get_started#show'
    post 'get-started/validate' => 'get_started#validate', as: :get_started_validation
    get 'safetyandcertifications', to: redirect("support/safety")

    get 'privacy_policy.html', to: redirect('https://www.harman.com/privacy-policy'), as: :privacy_policy
    get 'terms_of_use.html', to: redirect('https://www.harman.com/terms-use'), as: :terms_of_use
    get 'new_products.html', to: redirect("#{ENV['PRO_SITE_URL']}/lp/new-products"), as: :new_products

    match 'discontinued_products' => 'products#discontinued_index', as: :discontinued_products, via: :all
    get 'channel' => 'main#channel'
    get "videos(/:id)" => "videos#index", as: :videos
    get "videos/play/:id" => "videos#play", as: :play_video
    match '/product_documents(/:language(/:document_type))' => "product_documents#index", via: :all
    match '/downloads(/:language(/:document_type))' => "product_documents#index", as: :downloads, via: :all
    get '/support_downloads/product' => "support#selected_downloads_by_product", as: :selected_downloads_by_product, defaults: { format: :js }
    get '/support_downloads/product/:id(.:format)' => "support#downloads_by_product", as: :support_downloads_by_product, defaults: { format: :js }
    get '/support_downloads/type' => "support#selected_downloads_by_type", as: :selected_downloads_by_type, defaults: { format: :js }
    get '/support_downloads/type/:id(.:format)' => "support#downloads_by_type", as: :support_downloads_by_type, defaults: { format: :js }
    get '/support_downloads(/:view_by(/:selected_object))' => "support#downloads", as: :support_downloads
    post '/support_downloads' => "support#downloads_search", as: :support_downloads_search
    match '/software' => 'softwares#index', as: :software_index, via: :all
    match '/firmware' => 'softwares#firmware', as: :firmware_index, via: :all
    match '/support/warranty_registration(/:product_id)' => 'support#warranty_registration', as: :warranty_registration, via: :all
    match '/support/parts' => 'support#parts', as: :parts_request, via: :all
    match '/support/jitc_certified_firmware_request' => 'jitc_requests#index', as: :jitc_certified_firmware_request, message_type: "jitc_certified_firmware_request", via: :all
    match '/support/security_information_request' => 'jitc_requests#index', as: :security_information_request, message_type: "security_information_request", via: :all
    match '/support/rma' => 'support#rma', as: :rma_request, via: :all
    match '/support/rma_repair' => 'support#rma', as: :rma_repair_request, message_type: "rma_repair_request", via: :all
    match '/support/rma_credit' => 'support#rma', as: :rma_credit_request, message_type: "rma_credit_request", via: :all
    match '/support/contact' => 'support#contact', as: :support_contact, via: :all
    match '/support/service_lookup', to: redirect("#{ENV['PRO_SITE_URL']}/service_centers"), as: :service_lookup, via: :all
    get '/support/speaker_tunings' => 'support#speaker_tunings', as: :speaker_tunings
    get '/support/cad' => 'support#cad', as: :support_cad
    match '/support/vintage_repair' => 'support#vintage_repair', as: :vintage_repair, via: :all
    match '/support/all_repair', to: redirect("#{ENV['PRO_SITE_URL']}/service_centers"), as: :support_all_repair, via: :all
    match '/catalog_request' => 'support#catalog_request', as: :catalog_request, via: :all
    get '/support/warranty_policy' => 'support#warranty_policy', as: :warranty_policy
    get '/support/protected' => 'gated_support#index', as: :gated_support
    get "support/tech_support" => "support#tech_support"
    get "support/repairs" => "support#repairs"
    get "support/rsos" => "support#rsos"
    get "support/compliance" => "support#safety", as: :compliance
    get "support/safety", to: redirect('support/compliance'), as: :safety

    match '/sitemap(.:format)' => 'sitemap#show', as: :locale_sitemap, via: :all, defaults: { format: :xml }

    match '/international_distributors' => 'distributors#index', as: :international_distributors, via: :all
    get '/where_to_find/partner_search(/:format)' => 'where_to_find#partner_search', as: :partner_search
    get '/where_to_find/vertec_vtx_owners_search(/:format)' => 'where_to_find#vertec_vtx_owners_search', as: :vertec_vtx_owners_search
    get '/where_to_find(/:zip)' => 'where_to_find#index', as: :where_to_find
    get '/where_to_buy(/:zip)', to: redirect('where_to_find'), as: :where_to_buy
    get '/enquire(/:zip)' => 'where_to_find#index', as: :enquire

    #match '/support(/:action(/:id))' => "support", as: :support, via: :all
    get '/support(/:product_id)' => "support#index", as: :support
    match '/rss(.:format)' => 'main#rss', as: :rss, via: :all, defaults: { format: :xml }
    match '/search' => 'search#index', as: :search, via: :all
    match '/rohs' => 'support#rohs', as: :rohs, via: :all
    match 'distributors_for/:brand_id' => 'distributors#minimal', as: :minimal_distributor_search, via: :all
    get 'tools/calculators'
    match '/' => 'main#index', as: :locale_root, via: :all
    # match '/:controller(/:action(/:id))', via: :all # Deprecated dynamic action segment

    get '/case_studies' => 'case_studies#index', as: :case_studies
    get '/case_studies/:slug' => 'case_studies#show', as: :case_study
    get '/case_studies/application/:vertical_market' => 'case_studies#index', as: :case_studies_by_vertical_market
    get '/case_studies/filter/:asset_type/:vertical_market' => 'case_studies#index', as: :case_studies_by_asset_type

    get '/learning-sessions' => 'learning_sessions#index', as: :learning_sessions

    # Custom Shop
    get 'custom_shop' => 'custom_shop#index', as: :custom_shop
    namespace :custom_shop do
      get 'cart' => "custom_shop_carts#show", as: :cart
      get 'request_submitted' => "custom_shop_price_requests#request_submitted", as: :request_submitted
      resources :products, only: :show
      resources :product_families, only: :show
      resources :custom_shop_price_requests
      resources :custom_shop_carts
      resources :custom_shop_line_items
    end
    get '/profile' => "profile#show", as: :profile

    get "Forum(/:url_params)", to: redirect("https://proforums.harman.com")
    match "*custom_route" => "pages#show", as: :custom_route, via: :all
  end  # scope "(:locale)", locale: /

  match '*a', to: 'errors#404', via: :all

end
