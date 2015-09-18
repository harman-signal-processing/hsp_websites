namespace :digitech do

  desc "One time site update for digitech and dod"
  task :upgrade => :environment do

    digitech = Brand.find("digitech")

    digitech.default_website.features.update_all(remove_on: 1.day.ago)
    digitech_features = digitech.settings.where(setting_type: 'homepage feature')
    digitech_features.where("start_on >= ?", Date.today).update_all(start_on: 1.day.ago)

    side_tabs = digitech.settings.where(name: 'side_tabs').first_or_create
    side_tabs.update_attributes(setting_type: 'string', string_value: '')

    main_tabs = digitech.settings.where(name: 'main_tabs').first_or_create
    main_tabs.update_attributes(setting_type: 'string',
                                string_value: 'description|extended_description|documentation|downloads|features|specifications|training_modules|artists|tones|news_and_reviews|support')

    old_slides = Setting.slides(digitech.default_website)
    old_slides.update_all(remove_on: 1.day.ago)
    new_slides = digitech.settings.where(setting_type: 'slideshow frame').where("remove_on != ?", 1.day.ago)
    new_slides.update_all(start_on: 1.day.ago)

    dod = Brand.find("dod")

    side_tabs = dod.settings.where(name: 'side_tabs').first_or_create
    side_tabs.update_attributes(setting_type: 'string', string_value: '')

    main_tabs = dod.settings.where(name: 'main_tabs').first_or_create
    main_tabs.update_attributes(setting_type: 'string',
                                string_value: 'description|extended_description|documentation|downloads|features|specifications|training_modules|artists|tones|news_and_reviews|support')
  end
end
