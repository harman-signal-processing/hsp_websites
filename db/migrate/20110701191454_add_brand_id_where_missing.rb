class AddBrandIdWhereMissing < ActiveRecord::Migration
  def self.up
    add_column :captchas, :brand_id, :integer
    Captcha.update_all(:brand_id => BRAND_ID)
    add_column :dealers, :brand_id, :integer
    Dealer.update_all(:brand_id => BRAND_ID)
    add_column :news, :brand_id, :integer
    News.update_all(:brand_id => BRAND_ID)
    add_column :pages, :brand_id, :integer
    Page.update_all(:brand_id => BRAND_ID)
    add_column :promotions, :brand_id, :integer
    Promotion.update_all(:brand_id => BRAND_ID)
    add_column :service_centers, :brand_id, :integer
    ServiceCenter.update_all(:brand_id => BRAND_ID)
    add_column :softwares, :brand_id, :integer
    Software.update_all(:brand_id => BRAND_ID)
    
  end

  def self.down
    remove_column :softwares, :brand_id
    remove_column :service_centers, :brand_id
    remove_column :promotions, :brand_id
    remove_column :pages, :brand_id
    remove_column :news, :brand_id
    remove_column :dealers, :brand_id
    remove_column :captchas, :brand_id
  end
end