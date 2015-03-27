namespace :bss do

  desc "Temporary script to setup new BSS settings for 2015"
  task :setup2015 => :environment do
    bss = Brand.find "bss"
    bss.update_column(:has_online_retailers, true)
    bss.update_column(:show_pricing, true)

    side_tabs = bss.settings.where(name: "side_tabs").first
    side_tabs.update_column(:string_value, "")

    main_tabs = bss.settings.where(name: "main_tabs").first
    main_tabs.update_column(:string_value, "description|extended_description|documentation|downloads|features|specifications|training_modules|news|reviews|support")

    featured = bss.settings.where(name: "featured_products").first_or_initialize
    featured.setting_type = "string"
    featured.string_value = "blu-103"
    featured.save

    headline = bss.settings.where(name: "homepage_headline").first_or_initialize
    headline.setting_type = "string"
    headline.string_value = "Outstanding Quality, Undaunted by Scale."
    headline.save

    headline_link = bss.settings.where(name: "homepage_headline_product_family_id").first_or_initialize
    headline_link.setting_type = "string"
    headline_link.string_value = "soundweb-london"
    headline_link.save

    headline_class = bss.settings.where(name: "homepage_headline_overlay_class").first_or_initialize
    headline_class.setting_type = "string"
    headline_class.string_value = "large-10 medium-11 small-12 columns"
    headline_class.save

    Rake::Task["setup:verify_gwt"].invoke
  end

end
