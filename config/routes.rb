require "domain_conditions"

HarmanSignalProcessingWebsite::Application.routes.draw do

  get "/images/bar/:color.png" => "marketing_queue#bar", as: :bar
  get "signups/new"
  get "signup/complete" => "signups#complete", as: :signup_complete
  get "epedal_labels/index"

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
      resources :brands, only: [:index, :show]
      resources :products, only: :show
    end
  end

  constraints(ToolkitDomain) do 
    match '/' => 'toolkit#index', as: :toolkit_root
    devise_for :toolkit_users, 
      path: "users",
      class_name: "User", 
      controllers: { 
        sessions: "toolkit/users/sessions",
        registrations: "toolkit/users/registrations",
        confirmations: "toolkit/users/confirmations",
        passwords: "toolkit/users/passwords",
        unlocks: "toolkit/users/unlocks"
      }
    devise_scope :toolkit_user do 
      get '/users/sign_up/:signup_type' => 'toolkit/users/registrations#new', as: :new_toolkit_user
      get '/new_user' => 'toolkit/users/registrations#select_signup_type', as: :select_signup_type
    end
    namespace :toolkit do
      resources :brands, only: :show do 
        resources :products, :promotions, only: [:index, :show]
        resources :product_families, :toolkit_resources, :toolkit_resource_types, only: [:show]
      end
    end
  end

  constraints(QueueDomain) do 
    match '/' => 'marketing_queue#index', as: :marketing_queue_root
    get 'staff_meeting' => 'marketing_queue#staff_meeting'
    get 'user_workload/:id' => 'marketing_queue#workload', as: :user_workload
    devise_for :marketing_queue_users, 
      path: "users",
      class_name: "User", 
      controllers: { 
        sessions: "marketing_queue/users/sessions",
        registrations: "marketing_queue/users/registrations",
        confirmations: "marketing_queue/users/confirmations",
        passwords: "marketing_queue/users/passwords",
        unlocks: "marketing_queue/users/unlocks"
      }
    namespace :marketing_queue do
      resources :brands do 
        get '/calendar(/:year(/:month))' => 'brands#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
        resources :marketing_projects, :marketing_tasks
      end
      resources :marketing_projects do 
        resources :marketing_comments, only: [:create, :destroy]
        resources :marketing_attachments
        collection do
          get :overview
        end
      end
      get 'load_marketing_calendar(/:id)' => 'marketing_calendars#show', as: :load_marketing_calendar
      resources :marketing_calendars do 
        get ':id/calendar((/:year(/:month))/:brand_id)' => 'marketing_calendars#show', as: :project_calendar, constraints: {year: /\d{4}/, month: /\d{1,2}/}
      end
      resources :marketing_tasks, 
        :marketing_project_types, 
        :marketing_project_type_tasks,
        :marketing_attachments
      resources :marketing_tasks do 
        resources :marketing_comments, only: [:create, :destroy]
        resources :marketing_attachments
        member do 
          get :toggle
          get :switch_currently_with
        end
      end
    end
  end

  resources :registered_downloads
  # debugging help
  match "/site_info" => 'main#site_info'
 
  devise_for :artists, controllers: { registrations: "artist_registrations" }
  devise_scope :artists do
    get 'artists', to: 'artists#index', as: :artist_root
  end
  
  match '/activate(/:software_name(/:challenge))' => 'softwares#activate', as: :software_activation

  match '/:registered_download_url/register(/:code)' => 'registered_downloads#register', as: :register_to_download
  match '/:registered_download_url/confirm' => 'registered_downloads#confirmation', as: :confirm_download_registration
  match '/:registered_download_url/get_it/:download_code' => 'registered_downloads#show', as: :registered_download
  match '/:registered_download_url/downloadr/:download_code' => 'registered_downloads#download', as: :registered_download_file

  match '/favicon.ico' => 'main#favicon'
  match '/dashboard' => 'admin#index', as: :dashboard
  match "/admin" => "admin#index", as: :admin_root, locale: I18n.default_locale
  match 'sitemap(.:format)' => 'main#sitemap', as: :sitemap
    
  # An example of a custom top-level landing page route:
  # match "/switchyourthinking" => "pages#show", custom_route: "switchyourthinking", locale: I18n.default_locale

  # Legacy links redirected to current links. The constant "_REDIRECTS" are found in
  # config/initializers/redirects.rb
  # These are only needed for site-specific routing (where you don't want a particular URL
  # to work on the other sites)  
  constraints(DigitechDomain) do
    # match '/soundcomm(/:page)', to: redirect("/#{I18n.default_locale}/soundcomm"), as: :soundcomm, locale: I18n.default_locale
    match '/soundcomm(/:page)', to: redirect('http://soundcommunity.digitech.com/'), as: :soundcomm, locale: I18n.default_locale
    get 'gctraining' => 'pages#gctraining'
    get 'epedal_labels/fulfilled/:id/:secret_code' => 'label_sheet_orders#fulfill', as: :label_sheet_order_fulfillment
    get 'epedal_labels/new(/:epedal_id)' => 'label_sheet_orders#new', as: :epedal_labels_order_form
    get 'epedal_label_thanks' => 'label_sheet_orders#thanks', as: :thanks_label_sheet_order
    resources :label_sheet_orders, only: [:new, :create] 
  end
  
  # The constraint { locale: /#{WebsiteLocale.all_unique_locales.join('|')}/ } limits the locale
  # to those configured in the WebsiteLocale model which is configured in the admin area and reverts 
  # to AVAILABLE_LOCALES in config/initializers/i18n.rb in case of problems
  
  # Main routing
  root to: 'main#default_locale'
  scope "(:locale)", locale: /#{WebsiteLocale.all_unique_locales.join('|')}/ do 
    scope "/admin" do 
      devise_for :users, path: :site_users
      devise_scope :user do
        get 'admin', to: 'admin#index', as: :user_root 
      end
    end
    namespace :admin do
      match "brand_toolkit_contacts/load_user/:id" => 'brand_toolkit_contacts#load_user'
      get 'show_campaign/:id' => 'signups#show_campaign', as: 'show_campaign'
      resources :products do
        collection do
          get :rohs
          put :update_rohs
          get :harman_employee_pricing
          put :update_harman_employee_pricing
        end
        member do
          get :delete_background
        end
      end
      resources :product_families do
        collection { post :update_order }
        member do
          get :delete_background, :delete_family_photo, :delete_family_banner, :delete_title_banner
        end
      end
      resources :warranty_registrations do
        collection { put :search }
      end
      resources :product_family_products do
        collection { post :update_order }
      end
      resources :product_attachments do
        collection { post :update_order }
      end
      resources :artists do
        collection { post :update_order }
        member { post :reset_password }
      end
      resources :settings do 
        collection do
          get :homepage
          post :update_slides_order
          post :update_features_order
          post :big_bottom_box
        end
        member do
          get :copy
        end
      end
      resources :effect_types, only: [:create] do
        collection { post :update_order }
      end
      resources :users do
        member do
          post :reset_password
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
      resources :rso_navigations do
        collection do
          post :update_order
        end
      end
      resources :market_segment_product_families do
        collection { post :update_order }
      end
      resources :product_training_modules, :software_training_modules, :parent_products, :product_softwares, :brand_toolkit_contacts do
        collection { post :update_order }
      end
      resources :blogs do
        resources :blog_articles
      end
      resources :label_sheet_orders do 
        collection { get :subscribers }
      end
      resources :product_prices do 
        collection { put :update_all }
      end
      resources :toolkit_resources do 
        member { get :delete_preview }
      end
      resources :news do
        member { put :notify }
      end
      resources :softwares do 
        collection { post :upload }
      end
      resources :service_centers, 
        :software_training_classes,
        :product_training_classes,
        :product_review_products,
        :locale_product_families,
        :toolkit_resource_types,
        :product_site_elements,
        :product_introductions,
        :online_retailer_links,
        :online_retailer_users,
        :tone_library_patches,
        :software_attachments,
        :product_audio_demos,
        :rso_monthly_reports,
        :clinician_questions,
        :product_suggestions,
        :product_amp_models,
        :tone_library_songs,
        :product_promotions,
        :product_documents, 
        :clinician_reports,
        :product_cabinets,
        :online_retailers,
        :training_classes,
        :training_modules,
        :product_effects,
        :market_segments,
        :website_locales,
        :product_reviews,
        :artist_products,
        :clinic_products,
        :us_rep_regions,
        :specifications,
        :pricing_types,
        :site_elements,
        :news_products,
        :rep_questions,
        :label_sheets,
        :distributors,
        :artist_tiers, 
        :audio_demos,
        :rep_reports,
        :promotions,
        :amp_models,
        :us_regions,
        :demo_songs,
        :rso_panels,
        :rso_pages,
        :cabinets,
        :websites,
        :captchas,
        :us_reps,
        :regions,
        :effects,
        :signups,
        :dealers,
        :clinics,
        :brands,
        :pages,
        :faqs
        
      #match "translations/:target_locale(/:action)" => "content_translations", as: :translations
      scope path: '/:target_locale', target_locale: /#{WebsiteLocale.all_unique_locales.join('|')}/ do 
        resources :content_translations do
          collection {get :list, :combined}
          collection {post :combined}
        end
      end
      
    end # end admin scope
    
    # constraints(DigitechDomain) do
    #   mount Forem::Engine, at: "/soundcomm"
    # end
    get 'teaser' => 'main#teaser'
    get 'teaser2' => 'main#teaser'
    resources :signups, only: [:new, :create]  
    get 'now-youll-know' => 'main#teaser_complete', as: :teaser_complete  
    resources :us_reps, :distributors, only: [:index, :show] do
      collection { get :search }
    end
    # get "distributors#search"
    resources :softwares, only: [:index, :show] do
      member { get :download }
    end
    resources :news, only: [:index, :show] do
      collection { get :archived }
    end
    get "artists/become_an_artist" => 'artists#become', as: :become_an_artist
    get "artists/all(/:letter)" => 'artists#all', as: :all_artists
    resources :artists, only: [:index, :show] do
      collection { 
        get :list
        get :touring
      }
    end
    resources :training_modules, :training_classes, only: [:index, :show]
    get 'training' => 'support#training', as: :training
    resources :market_segments, :pages, :product_reviews, :product_families, :demo_songs, :promotions, only: [:index, :show]
    get 'introducing/:id' => 'products#introducing', as: :product_introduction
    get 'products/songlist/:id.:format' => 'products#songlist', as: :product_songlist
    resources :products, only: [:index, :show, :discontinued] do
      member do
        get :buy_it_now
        get :songlist
        get :preview
        put :preview
      end
      collection do 
        match :compare
      end
    end
    get 'products/:id(/:tab)' => 'products#show', as: :product
    resources :blogs, only: [:index, :show] do
      resources :blog_articles, only: :show
    end
    resources :tone_library_songs, only: :index
    resources :product_documents, only: :index
    # Enable this to show clinics on public site
    #resources :clinics, only: [:index, :show]

    get 'channel' => 'main#channel'
    get "videos(/:id)" => "videos#index", as: :videos
    get "videos/play/:id" => "videos#play", as: :play_video
    get '/zips/:download_type.zip' => 'support#zipped_downloads', as: :zipped_downloads
    match '/product_documents(/:language(/:document_type))' => "product_documents#index"
    match '/downloads(/:language(/:document_type))' => "product_documents#index", as: :downloads
    get '/support_downloads' => "support#downloads", as: :support_downloads
    match '/tone_library/:product_id/:tone_library_song_id(.:ext)' => "tone_library_songs#download", as: :tone_download 
    match '/tone_library' => "tone_library_songs#index", as: :tone_library
    match '/software' => 'softwares#index', as: :software_index
    match '/support/warranty_registration(/:product_id)' => 'support#warranty_registration', as: :warranty_registration
    match '/support/parts' => 'support#parts', as: :parts_request
    match '/support/rma' => 'support#rma', as: :rma_request
    get '/support/warranty_policy' => 'support#warranty_policy', as: :warranty_policy
    match '/international_distributors' => 'distributors#index', as: :international_distributors
    match '/sitemap(.:format)' => 'main#locale_sitemap', as: :locale_sitemap
    match '/where_to_buy(/:zip)' => 'main#where_to_buy', as: :where_to_buy 
    match '/support(/:action(/:id))' => "support", as: :support
    match '/community' => 'main#community', as: :community
    match '/rss(.:format)' => 'main#rss', as: :rss
    match '/search' => 'main#search', as: :search
    match '/rohs' => 'support#rohs', as: :rohs
    match 'distributors_for/:brand_id' => 'distributors#minimal', as: :minimal_distributor_search
    match '/' => 'main#index', as: :locale_root
    match '/:controller(/:action(/:id))'
    match "*custom_route" => "pages#show", as: :custom_route
  end

  match '*a', to: 'errors#404'

end
