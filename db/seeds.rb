# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Create product statuses
ProductStatus.create([{:name => "In Development"},
  {:name => "Announced", :show_on_website => true},
  {:name => "In Production", :show_on_website => true},
  {:name => "Discontinued", :show_on_website => true, :discontinued => true}
  ])

# Create Brands
["DigiTech", "dbx", "Lexicon", "BSS", "Vocalist", "HardWire", "JBL Commercial"].each do |b|
  Brand.find_or_create_by_name(b)
end

# Find the brand for this site
digitech = Brand.find_by_name("DigiTech")

# Create Product Families
multi = ProductFamily.create(:name => "Multi Effects", :brand => digitech)
pedals = ProductFamily.create(:name => "Stompboxes", :brand => digitech)
ProductFamily.create(:name => "Specialty Pedals", :brand => digitech)
ProductFamily.create(:name => "Bass Multi Effects", :parent_id => multi.id, :brand => digitech)
ProductFamily.create(:name => "Bass Pedals", :parent_id => pedals.id, :brand => digitech)

# Import dealers
keys = [:name, :name2, :name3, :name4, :address, :city, :state, :zip, :telephone, :fax, :email, :account_number]
File.open(Rails.root.join "db", "digitech.dat").each do |row|
  d = {}
  row.chomp!.split(/\s?\|\s?/).each_with_index do |val, i|
    d[keys[i]] = val
  end
  dealer = Dealer.find_or_initialize_by_account_number_and_address(d[:account_number], d[:address])
  dealer.attributes = d
  dealer.brand_id = 1
  dealer.save
end

site_name = Setting.find_or_initialize_by_name("site_name")
site_name.setting_type = "string"
site_name.string_value = "DigiTech Guitar Effects"
site_name.save

# site_url = Setting.find_or_initialize_by_name("site_url")
# site_url.setting_type = "string"
# site_url.string_value = "http://www.digitech.com"
# site_url.save

ga_code = Setting.find_or_initialize_by_name("google_analytics_account")
ga_code.setting_type = "string"
ga_code.string_value = "UA-5425126-1"
ga_code.save

twitter = Setting.find_or_initialize_by_name("twitter")
twitter.setting_type = "string"
twitter.string_value = "DigiTech"
twitter.save

facebook = Setting.find_or_initialize_by_name("facebook")
facebook.setting_type = "string"
facebook.string_value = "http://www.facebook.com/pages/DigiTech/146474645377756"
facebook.save

myspace = Setting.find_or_initialize_by_name("myspace")
myspace.setting_type = "string"
myspace.string_value = "http://www.myspace.com/digitechfx"
myspace.save

youtube = Setting.find_or_initialize_by_name("youtube")
youtube.setting_type = "string"
youtube.string_value = "http://www.youtube.com/user/DigiTechFX"
youtube.save

meta_keywords = Setting.find_or_initialize_by_name("default_meta_tag_keywords")
meta_keywords.setting_type = "text"
meta_keywords.save

meta_description = Setting.find_or_initialize_by_name("default_meta_tag_description")
meta_description.setting_type = "text"
meta_description.save

address_and_phone = Setting.find_or_initialize_by_name("address_and_phone")
address_and_phone.setting_type = "text"
address_and_phone.text_value = "DigiTech<br/>8760 South Sandy Pkwy.<br/>Sandy, UT 84070<br/>(801) 566-88800"
address_and_phone.save

support_email = Setting.find_or_initialize_by_name("support_email")
support_email.setting_type = "string"
support_email.string_value = "support@digitech.com"
support_email.save

about_text = Setting.find_or_initialize_by_name("about_text")
about_text.setting_type = "text"
about_text.text_value = "DigiTech&reg; is a Harman company specializing in guitar effects pedals."
about_text.save
