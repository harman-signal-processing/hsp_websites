require "domain_conditions"

HarmanSignalProcessingWebsite::Application.routes.draw do

  get "robots" => "main#robots", defaults: { format: 'txt' }
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
      end
      resources :products, only: :show # for backwards compat
    end
  end

  constraints(ToolkitDomain) do
    get '/' => 'toolkit#index', as: :toolkit_root
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
  get 'sitemap(.:format)' => 'main#sitemap', as: :sitemap

  # An example of a custom top-level landing page route:
  # match "/switchyourthinking" => "pages#show", custom_route: "switchyourthinking", locale: I18n.default_locale

  # Legacy links redirected to current links. The constant "_REDIRECTS" are found in
  # config/initializers/redirects.rb
  # These are only needed for site-specific routing (where you don't want a particular URL
  # to work on the other sites)

  constraints(AkgDomain) do
    # Social Media routes for AKG
    get '/facebook', to: redirect('https://www.facebook.com/AKG?_ga=1.29192636.1674201073.1456831551')
    get '/twitter', to: redirect('https://twitter.com/AKGaudio')
    get '/instagram', to: redirect('http://instagram.com/akgaudio')
  end  #  constraints(AkgDomain) do

  constraints(AmxDomain) do
    # Social Media routes for AMX
    get '/twitter', to: redirect('http://www.twitter.com/amxtalk')
    get '/facebook', to: redirect('https://www.facebook.com/amxtalk')
    get '/youtube', to: redirect('https://www.youtube.com/user/AMXtalk')
    get '/google', to: redirect('https://www.google.com/+amxautomate')
    get '/linkedin', to: redirect('https://www.linkedin.com/company/amx')

    begin
      Brand.find("amx").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No AMX brand found--probably a fresh test database which doesn't matter.
    end
  end  #  constraints(AmxDomain) do

  constraints(BssDomain) do
    get '/network-audio' => 'pages#network_audio'

    begin
      Brand.find("bss").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No BSS brand found--probably a fresh test database which doesn't matter.
    end

    # Social Media routes for BSS
    get '/twitter', to: redirect('http://www.twitter.com/bssaudio')
    get '/youtube', to: redirect('https://www.youtube.com/user/bssaudio')
    get '/google', to: redirect('https://plus.google.com/116673860909914873281/posts')
  end  #  constraints(BssDomain) do

  constraints(CrownDomain) do
    get '/trucktourgiveaway(.:format)' => 'signups#new', defaults: { campaign: "Crown-TruckTour-Flip-2015" }
    get '/network-audio' => 'pages#network_audio'

    begin
      Brand.find("crown").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No Crown brand found--probably a fresh test database which doesn't matter.
    end

    # Social Media routes for Crown
    get '/twitter', to: redirect('http://www.twitter.com/crownaudio')
    get '/facebook', to: redirect('https://www.facebook.com/CrownbyHarman')
    get '/youtube', to: redirect('https://www.youtube.com/user/CrownInternational')
    get '/google', to: redirect('https://plus.google.com/100964114345403679773')
    get '/instgram', to: redirect('https://instagram.com/crown_audio')
    get '/linkedin', to: redirect('https://www.linkedin.com/company/crown-international')
  end  #  constraints(CrownDomain) do

  constraints(DbxDomain) do
    #  Social Media routes for dbx
    get '/twitter', to: redirect('http://www.twitter.com/dbxpro')
    get '/facebook', to: redirect('https://www.facebook.com/dbxpro')
    get '/youtube', to: redirect('https://www.youtube.com/user/dbxprofessional')
    get '/google', to: redirect('https://plus.google.com/u/0/100759493077882514506/posts')

    begin
      Brand.find("dbx").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No dbx brand found--probably a fresh test database which doesn't matter.
    end
  end  #  constraints(DbxDomain) do

  constraints(DigitechDomain) do
    # match '/soundcomm(/:page)', to: redirect("/#{I18n.default_locale}/soundcomm"), as: :soundcomm, locale: I18n.default_locale
    match '/soundcomm(/:page)', to: redirect('http://soundcommunity.digitech.com/'), as: :soundcomm, locale: I18n.default_locale, via: :all
    #get 'gctraining' => 'pages#gctraining'
    # E-pedal label sheet ordering removed 2018-02-21
    #get "epedal_labels/index"
    #get 'epedal_labels/fulfilled/:id/:secret_code' => 'label_sheet_orders#fulfill', as: :label_sheet_order_fulfillment
    #get 'epedal_labels/new(/:epedal_id)' => 'label_sheet_orders#new', as: :epedal_labels_order_form
    #get 'epedal_label_thanks' => 'label_sheet_orders#thanks', as: :thanks_label_sheet_order
    #resources :label_sheet_orders, only: [:new, :create]

    begin
      Brand.find("digitech").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No digitech brand found--probably a fresh test database which doesn't matter.
    end

    # Social Media routes for Digitech
    get '/twitter', to: redirect('http://www.twitter.com/DigiTech')
    get '/facebook', to: redirect('https://www.facebook.com/digitech')
    get '/youtube', to: redirect('https://www.youtube.com/user/digitechfx')
    get '/google', to: redirect('https://plus.google.com/+DigiTechFX/posts')
    get '/instagram', to: redirect('https://instagram.com/digitechfx')
  end  #  constraints(DigitechDomain) do

  constraints(JblProDomain) do
    # Social Media routes for JBL Pro
    get '/instagram', to: redirect('https://www.instagram.com/jbl_pro/')
    get '/facebook', to: redirect('https://www.facebook.com/jblprofessional')
    get '/twitter', to: redirect('https://twitter.com/TheJBLpro')
    get '/youtube', to: redirect('http://www.youtube.com/TheJBLProfessional')
  end  #  constraints(JblProDomain) do

  constraints(LexiconDomain) do
    # Social Media routes for LexiconPro
    get '/twitter', to: redirect('http://www.twitter.com/LexiconPro')
    get '/facebook', to: redirect('https://www.facebook.com/lexiconpro')
    get '/youtube', to: redirect('https://www.youtube.com/user/LexiconPro')
    get '/google', to: redirect('https://plus.google.com/100996659132374613095/posts/')

    begin
      Brand.find("lexicon").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No Lexicon brand found--probably a fresh test database which doesn't matter.
    end
  end  #  constraints(LexiconDomain) do

  constraints(MartinDomain) do
    begin
      Brand.find("martin").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No Martin brand found--probably a fresh test database which doesn't matter.
    end
    # Removed as requested:
    #match "/en-us/fixtures-request" => "support#fixtures_request", as: "fixtures_request", via: [:get, :post]
  end  #  constraints(MartinDomain) do

  constraints(SoundcraftDomain) do
    # Social Media routes for Soundcraft
    get '/twitter', to: redirect('http://www.twitter.com/SoundcraftUK')
    get '/facebook', to: redirect('https://www.facebook.com/SoundcraftMixers')
    get '/youtube', to: redirect('https://www.youtube.com/SoundcraftUK')
    get '/instagram', to: redirect('https://instagram.com/soundcraftmixers')
    get '/linkedin', to: redirect('https://www.linkedin.com/company/soundcraft-studer')

    begin
      Brand.find("soundcraft").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No Soundcraft brand found--probably a fresh test database which doesn't matter.
    end
  end  #  constraints(SoundcraftDomain) do

  constraints(StuderDomain) do
    # Social Media routes for Studer
    get '/twitter', to: redirect('http://www.twitter.com/StuderAudio')
    get '/facebook', to: redirect('https://www.facebook.com/StuderCreateSound/')
    get '/youtube', to: redirect('https://www.youtube.com/StuderProfessional')
    get '/linkedin', to: redirect('https://www.linkedin.com/company/studer-professional-audio-gmbh')

    begin
      Brand.find("studer").products.each do |product|
        get "/#{product.friendly_id}", to: redirect("/products/#{product.friendly_id}")
        get "/#{product.friendly_id.gsub(/\W/, '')}", to: redirect("/products/#{product.friendly_id}")
      end
    rescue
      # No Studer brand found--probably a fresh test database which doesn't matter.
    end
  end  #  constraints(StuderDomain) do

  # The constraint { locale: /#{WebsiteLocale.all_unique_locales.join('|')}/ } limits the locale
  # to those configured in the WebsiteLocale model which is configured in the admin area and reverts
  # to AVAILABLE_LOCALES in config/initializers/i18n.rb in case of problems

  # Main routing
  root to: 'main#default_locale'
  scope "(:locale)", locale: /#{WebsiteLocale.all_unique_locales.join('|')}/ do
    constraints(AmxDomain) do
      # get 'contacts' => 'main#where_to_buy', as: :amx_contacts
      get '/contacts' => 'support#index'
      get '/partners' => 'manufacturer_partners#index'
      resources :vip_programmers, only: [:index, :show]      
    end  # constraints(AmxDomain) do

    constraints(BssDomain) do
      get 'bss-network-audio' => 'pages#network_audio'
      get 'network-audio' => 'pages#network_audio'
    end

    constraints(CrownDomain) do
      get 'network-audio' => 'pages#network_audio'
    end

    constraints(MartinDomain) do
      get 'safety-documents', to: redirect('/en-US/product_families/effect-fluids/safety-documents'), as: :martin_safety_documents
      get 'upgrade-me-to-supertech-just-this-once' => "gated_support#super_tech_upgrade"
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
      match "brand_toolkit_contacts/load_user/:id" => 'brand_toolkit_contacts#load_user', via: :all
      get 'show_campaign/:id' => 'signups#show_campaign', as: 'show_campaign'
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
      resources :market_segments do
        member do
          get :delete_banner_image
        end
        collection do
          post :update_order
        end
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
        member {
          put :notify  # no longer used--sends out press releases from admin tool
          get :delete_news_photo
        }
        resources :news_images
      end
      resources :systems do
        resources :system_options do
          resources :system_option_values
        end
        resources :system_components
        resources :system_rules do
          collection do
            put :enable_all
            put :disable_all
          end
          resources :system_rule_condition_groups do
            resources :system_rule_conditions
          end
          resources :system_rule_actions
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
      resources :specifications do
        member { patch :remove_from_group }
        collection { post :update_order }
      end
      resources :specification_groups do
        member { post :add_specification }
        collection { post :update_order }
      end
      resources :site_elements do
        resources :site_element_attachments
        collection { post :upload }
      end

      resources :vip_programmers,
        :vip_locations,
        :vip_global_regions,
        :vip_service_areas,
        :vip_programmer_locations,
        :vip_location_global_regions,
        :vip_location_service_areas,
        :vip_certifications,
        :vip_programmer_certifications,
        :vip_trainings,
        :vip_programmer_trainings,
        :vip_services,
        :vip_programmer_services,
        :vip_skills,
        :vip_programmer_skills,
        :vip_markets,
        :vip_programmer_markets,
        :vip_websites,
        :vip_programmer_websites,
        :vip_emails,
        :vip_programmer_emails,
        :vip_phones,
        :vip_programmer_phones,
        :vip_service_categories,
        :vip_service_service_categories

      resources :service_centers,
        :market_segment_product_families,
        :software_training_classes,
        :software_training_modules,
        :get_started_page_products,
        :product_training_modules,
        :product_training_classes,
        :product_review_products,
        :product_family_products,
        :locale_product_families,
        :product_part_group_part,
        :toolkit_resource_types,
        :brand_toolkit_contacts,
        :sales_region_countries,
        :product_site_elements,
        :product_introductions,
        :online_retailer_links,
        :online_retailer_users,
        :manufacturer_partners,
        :tone_library_patches,
        :software_attachments,
        :product_audio_demos,
        :product_suggestions,
        :product_attachments,
        :product_amp_models,
        :tone_library_songs,
        :product_promotions,
        :product_part_group,
        :product_softwares,
        :product_documents,
        :contact_messages,
        :product_cabinets,
        :online_retailers,
        :training_classes,
        :training_modules,
        :product_effects,
        :website_locales,
        :product_reviews,
        :artist_products,
        :parent_products,
        :product_badges,
        :product_videos,
        :faq_categories,
        :us_rep_regions,
        :system_options,
        :installations,
        :pricing_types,
        :news_products,
        :sales_regions,
        :label_sheets,
        :distributors,
        :artist_tiers,
        :audio_demos,
        :promotions,
        :amp_models,
        :us_regions,
        :demo_songs,
        :softwares,
        :cabinets,
        :websites,
        :captchas,
        :features,
        :us_reps,
        :effects,
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

      #match "translations/:target_locale(/:action)" => "content_translations", as: :translations
      scope path: '/:target_locale', target_locale: /#{WebsiteLocale.all_unique_and_incomplete_locales.join('|')}/ do
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
    get "signup" => "signups#new"
    get "signups" => "signups#new"
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
    resources :systems, only: [:index, :show] do
      resources :system_configurations, only: [:new, :create, :edit, :update] do
        member do
          post :new
          match ':access_hash/contact' => 'system_configurations#contact_form', as: :contact_form, via: [:get, :post]
          get ':access_hash' => 'system_configurations#show', as: :show
        end
      end
    end
    resources :solutions, only: [:index, :show]
    resources :faq_categories, only: [:index, :show]
    get "faqs" => 'faq_categories#index', as: :faqs
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
    resources :market_segments,
      :pages,
      :installations,
      :product_reviews,
      :demo_songs,
      :promotions, only: [:index, :show]
    resources :product_families, only: [:index, :show] do
      member do
        get 'safety-documents'
      end
    end
    get 'introducing/:id' => 'products#introducing', as: :product_introduction
    get 'products/songlist/:id.:format' => 'products#songlist', as: :product_songlist
    resources :products, only: [:index, :discontinued] do
      member do
        get :buy_it_now
        get :songlist
        get :preview
        get :photometric
        get :bom
        post :bom
        put :preview
      end
      collection do
        match :compare, via: :all
      end
    end
    get 'products/:id(/:tab)' => 'products#show', as: :product
    resources :tone_library_songs, only: :index
    resources :product_documents, only: :index
    resources :parts, only: [:index]
    resources :events, only: [:index, :show]
    resources :site_elements, only: [:show]

    get 'getting-started/ui', to: redirect('/get-started/ui-series')
    get 'get-started/ui', to: redirect('/get-started/ui-series')
    get 'get-started' => 'get_started#index', as: :get_started_index
    get 'get_started', to: redirect('/get-started'), as: :get_started_redirect
    get 'get-started/:id' => 'get_started#show', as: :get_started
    get 'getting-started/:id' => 'get_started#show'
    post 'get-started/validate' => 'get_started#validate', as: :get_started_validation
    get 'safetyandcertifications' => 'pages#safetyandcertifications'

    get 'privacy_policy.html', to: redirect('http://www.harman.com/privacy-policy'), as: :privacy_policy
    get 'terms_of_use.html', to: redirect('http://www.harman.com/terms-use'), as: :terms_of_use
    get 'new_products.html', to: redirect('http://pro.harman.com/lp/new-products'), as: :new_products

    match 'discontinued_products' => 'products#discontinued_index', as: :discontinued_products, via: :all
    get 'channel' => 'main#channel'
    get "videos(/:id)" => "videos#index", as: :videos
    get "videos/play/:id" => "videos#play", as: :play_video
    get '/zips/:download_type.zip' => 'support#zipped_downloads', as: :zipped_downloads
    match '/product_documents(/:language(/:document_type))' => "product_documents#index", via: :all
    match '/downloads(/:language(/:document_type))' => "product_documents#index", as: :downloads, via: :all
    get '/support_downloads(/:view_by(/:selected_object))' => "support#downloads", as: :support_downloads
    post '/support_downloads' => "support#downloads_search", as: :support_downloads_search
    match '/tone_library/:product_id/:tone_library_song_id(.:ext)' => "tone_library_songs#download", as: :tone_download, via: :all
    match '/tone_library' => "tone_library_songs#index", as: :tone_library, via: :all
    match '/software' => 'softwares#index', as: :software_index, via: :all
    match '/support/warranty_registration(/:product_id)' => 'support#warranty_registration', as: :warranty_registration, via: :all
    match '/support/parts' => 'support#parts', as: :parts_request, via: :all
    match '/support/rma' => 'support#rma', as: :rma_request, via: :all
    match '/support/rma_repair' => 'support#rma', as: :rma_repair_request, message_type: "rma_repair_request", via: :all
    match '/support/rma_credit' => 'support#rma', as: :rma_credit_request, message_type: "rma_credit_request", via: :all
    match '/support/contact' => 'support#contact', as: :support_contact, via: :all
    match '/support/service_lookup', to: redirect('https://pro.harman.com/service_centers'), as: :service_lookup, via: :all
    match '/support/troubleshooting' => 'support#troubleshooting', as: :support_troubleshooting, via: :all
    get '/support/speaker_tunings' => 'support#speaker_tunings', as: :speaker_tunings
    get '/support/cad' => 'support#cad', as: :support_cad
    match '/support/vintage_repair' => 'support#vintage_repair', as: :vintage_repair, via: :all
    match '/support/all_repair', to: redirect('https://pro.harman.com/service_centers'), as: :support_all_repair, via: :all
    match '/catalog_request' => 'support#catalog_request', as: :catalog_request, via: :all
    get '/support/warranty_policy' => 'support#warranty_policy', as: :warranty_policy
    get '/support/protected' => 'gated_support#index', as: :gated_support

    match '/international_distributors' => 'distributors#index', as: :international_distributors, via: :all
    match '/sitemap(.:format)' => 'main#locale_sitemap', as: :locale_sitemap, via: :all
    match '/where_to_buy(/:zip)' => 'main#where_to_buy', as: :where_to_buy , via: :all
    #match '/support(/:action(/:id))' => "support", as: :support, via: :all
    get '/support(/:product_id)' => "support#index", as: :support
    match '/community' => 'main#community', as: :community, via: :all
    match '/rss(.:format)' => 'main#rss', as: :rss, via: :all, defaults: { format: :xml }
    match '/search' => 'main#search', as: :search, via: :all
    match '/rohs' => 'support#rohs', as: :rohs, via: :all
    match 'distributors_for/:brand_id' => 'distributors#minimal', as: :minimal_distributor_search, via: :all
    get 'tools/calculators'
    match '/' => 'main#index', as: :locale_root, via: :all
#    match '/:controller(/:action(/:id))', via: :all # Deprecated dynamic action segment



    match "*custom_route" => "pages#show", as: :custom_route, via: :all
  end


  match '*a', to: 'errors#404', via: :all

end
