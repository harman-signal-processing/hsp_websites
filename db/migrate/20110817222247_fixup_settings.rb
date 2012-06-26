class OldSetting < ActiveRecord::Base
  establish_connection "settings_#{Rails.env}"
  set_table_name "settings"
end

class FixupSettings < ActiveRecord::Migration
  # This is going to be tricky. I have to create the "settings" table
  # in the regular database, add a "brand_id" column, move the data from
  # the old settings table and finally delete the old table...well I 
  # don't have to do that right away.
  def self.up
    create_table :settings do |t|
      t.string :name
      t.string :setting_type
      t.string :string_value
      t.integer :integer_value
      t.text :text_value
      t.string :slide_file_name
      t.integer :slide_file_size
      t.string :locale
      t.integer :brand_id
      t.string :slide_content_type
      t.datetime :slide_updated_at
      t.timestamps
    end
    ###### copy records
    OldSetting.all.each do |setting|
      new_setting = Setting.new(setting.attributes)
      puts " loaded: #{setting.inspect}"
      new_setting.brand_id = BRAND_ID
      new_setting.setting_type = "string" if !new_setting.string_value.blank?
      new_setting.setting_type = "integer" if !new_setting.integer_value.blank?
      new_setting.setting_type = "text" if !new_setting.text_value.blank?
      new_setting.setting_type = "slideshow frame" if !new_setting.slide_file_name.blank?
      new_setting.save! unless new_setting.setting_type == "string" && new_setting.name.match(/slide/i)
    end
    ###### add some new ones
    s = Setting.find_or_initialize_by_name("email_signup_url")
    s.brand_id = BRAND_ID
    s.setting_type = "string"
    s.string_value = "http://www.pages05.net/harmanprofessionalinc/Digitech/Digitech.com?Email="
    s.save!
    
    s = Setting.find_or_initialize_by_name("troubleshooting_url")
    s.brand_id = BRAND_ID
    s.setting_type = "string"    
    s.string_value = "http://na5.salesforce.com/sol/public/solutionbrowser.jsp?cid=02n70000000PeyS&orgId=00D70000000Jxp8"
    s.save!
    
    s = Setting.find_or_initialize_by_name("addthis_username")
    s.brand_id = BRAND_ID
    s.setting_type = "string"    
    s.string_value = "digitechfx"
    s.save!    
  end

  def self.down
    drop_table :settings
  end
end