namespace :lexicon do

  desc "One time site update for lexicon"
  task :upgrade => :environment do

    lexicon = Brand.find("lexicon")

    side_tabs = lexicon.settings.where(name: 'side_tabs').first_or_create
    side_tabs.update_attributes(setting_type: 'string', string_value: '')

    main_tabs = lexicon.settings.where(name: 'main_tabs').first_or_create
    main_tabs.update_attributes(setting_type: 'string',
                                string_value: 'description|extended_description|documentation|downloads|features|specifications|training_modules|reviews|news|support')

    featured_products = lexicon.settings.where(name: 'featured_products').first_or_create
    featured_products.update_attributes(setting_type: 'string',
                                        string_value: 'pcm96')

    #old_slides = Setting.slides(lexicon.default_website)
    #old_slides.update_all(remove_on: 1.day.ago)
    #new_slides = lexicon.settings.where(setting_type: 'slideshow frame').where("remove_on != ?", 1.day.ago)
    #new_slides.update_all(start_on: 1.day.ago)

  end
end
