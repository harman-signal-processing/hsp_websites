namespace :setup do

  desc "Add google site verification codes to all site settings"
  task :verify_gwt => :environment do
    bss = Brand.find "bss"
    gwt = bss.settings.where(name: "google_site_verification").first_or_initialize
    gwt.setting_type = "string"
    gwt.string_value = "QvpbZ3QWXFctjOPNOjk3_s_oKWekvqxf12Utx9UxjY8"
    gwt.save

    crown = Brand.find "crown"
    gwt = crown.settings.where(name: "google_site_verification").first_or_initialize
    gwt.setting_type = "string"
    gwt.string_value = "0-qAcislQV3STyhe8ceKB5LybaHHpwtjm03xDrRO0gc"
    gwt.save

    dbx = Brand.find "dbx"
    gwt = dbx.settings.where(name: "google_site_verification").first_or_initialize
    gwt.setting_type = "string"
    gwt.string_value = "8zMKY8o8lkI6RUgld6ZOYoKcCx1e-HJay9vJHnT7zME"
    gwt.save

    digitech = Brand.find "digitech"
    gwt = digitech.settings.where(name: "google_site_verification").first_or_initialize
    gwt.setting_type = "string"
    gwt.string_value = "wzOwJ6W1UIF7pcjTD8uhQy35nYuMTUPEbWEgJn436CQ"
    gwt.save

    dod = Brand.find "dod"
    gwt = dod.settings.where(name: "google_site_verification").first_or_initialize
    gwt.setting_type = "string"
    gwt.string_value = "q4FD7FkNxWfH-sh4LJcT7-24_Ej3KPDOoAn6v8Zcss0"
    gwt.save

    lexicon = Brand.find "lexicon"
    gwt = lexicon.settings.where(name: "google_site_verification").first_or_initialize
    gwt.setting_type = "string"
    gwt.string_value = "z2YH0Gt2csHUrioS-HaXOOGbuki9Tc3zr08nr0Yr08k"
    gwt.save

    studer = Brand.find "studer"
    gwt = studer.settings.where(name: "google_site_verification").first_or_initialize
    gwt.setting_type = "string"
    gwt.string_value = ""
    gwt.save

  end

end
