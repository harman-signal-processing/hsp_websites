class AddHomepageColumnsToSettings < ActiveRecord::Migration
  def self.up
    Brand.all.each do |brand|
      Setting.where(name: "homepage_left_column", brand_id: brand.id, string_value: "news", setting_type: "string").first_or_create
      Setting.where(name: "homepage_middle_column", brand_id: brand.id, string_value: "youtube", setting_type: "string").first_or_create
      Setting.where(name: "homepage_right_column", brand_id: brand.id, string_value: "twitter", setting_type: "string").first_or_create
    end
    dbx = Brand.where(name: "dbx").first
    s = Setting.where(brand_id: dbx.id, name: "homepage_middle_column").first
    s.update(:string_value => "facebook")
  end

  def self.down
    Setting.where(:name => "homepage_left_column").all.each{|s| s.destroy}
    Setting.where(:name => "homepage_right_column").all.each{|s| s.destroy}
    Setting.where(:name => "homepage_middle_column").all.each{|s| s.destroy}
  end
end
