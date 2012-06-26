class AddHomepageColumnsToSettings < ActiveRecord::Migration
  def self.up
    Brand.all.each do |brand|
      Setting.find_or_create_by_name_and_brand_id_and_string_value_and_setting_type("homepage_left_column", brand.id, "news", "string")
      Setting.find_or_create_by_name_and_brand_id_and_string_value_and_setting_type("homepage_middle_column", brand.id, "youtube", "string")
      Setting.find_or_create_by_name_and_brand_id_and_string_value_and_setting_type("homepage_right_column", brand.id, "twitter", "string")
    end
    dbx = Brand.find_by_name("dbx")
    s = Setting.find_by_brand_id_and_name(dbx.id, "homepage_middle_column")
    s.update_attributes(:string_value => "facebook")
  end

  def self.down
    Setting.where(:name => "homepage_left_column").all.each{|s| s.destroy}
    Setting.where(:name => "homepage_right_column").all.each{|s| s.destroy}
    Setting.where(:name => "homepage_middle_column").all.each{|s| s.destroy}
  end
end
