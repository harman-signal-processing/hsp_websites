class AddFlagsForBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :has_effects, :boolean, :default => false
    add_column :brands, :has_reviews, :boolean, :default => true
    add_column :brands, :has_faqs, :boolean, :default => true
    add_column :brands, :has_tone_library, :boolean, :default => false
    add_column :brands, :has_artists, :boolean, :default => true
    add_column :brands, :has_clinics, :boolean, :default => false
    add_column :brands, :has_software, :boolean, :default => true
    add_column :brands, :has_registered_downloads, :boolean, :default => false
    add_column :brands, :has_online_retailers, :boolean, :default => true
    add_column :brands, :has_distributors, :boolean, :default => true
    add_column :brands, :has_dealers, :boolean, :default => true
    add_column :brands, :has_service_centers, :boolean, :default => false
    
    Brand.all.each do |brand|
      if brand.name.match(/digitech/i)
        brand.update_attributes(
          :has_effects => true, 
          :has_reviews => true, 
          :has_faqs => true, 
          :has_tone_library => true,
          :has_artists => true,
          :has_clinics => true,
          :has_software => true,
          :has_registered_downloads => false,
          :has_online_retailers => true,
          :has_distributors => true,
          :has_dealers => true,
          :has_service_centers => true)
      elsif brand.name.match(/hardwire/i)
        brand.update_attributes(
          :has_effects => false, 
          :has_reviews => true, 
          :has_faqs => true, 
          :has_tone_library => false,
          :has_artists => true,
          :has_clinics => true,
          :has_software => true,
          :has_registered_downloads => false,
          :has_online_retailers => true,
          :has_distributors => true,
          :has_dealers => true,
          :has_service_centers => true)
      elsif brand.name.match(/vocalist/i)
        brand.update_attributes(
          :has_effects => true, 
          :has_reviews => true, 
          :has_faqs => true, 
          :has_tone_library => false,
          :has_artists => true,
          :has_clinics => true,
          :has_software => true,
          :has_registered_downloads => false,
          :has_online_retailers => true,
          :has_distributors => true,
          :has_dealers => true,
          :has_service_centers => true)
      elsif brand.name.match(/dbx/i)
        brand.update_attributes(
          :has_effects => false, 
          :has_reviews => true, 
          :has_faqs => true, 
          :has_tone_library => false,
          :has_artists => false,
          :has_clinics => false,
          :has_software => true,
          :has_registered_downloads => false,
          :has_online_retailers => true,
          :has_distributors => true,
          :has_dealers => true,
          :has_service_centers => true)
      elsif brand.name.match(/lexicon/i)
        brand.update_attributes(
          :has_effects => true, 
          :has_reviews => true, 
          :has_faqs => true, 
          :has_tone_library => false,
          :has_artists => true,
          :has_clinics => false,
          :has_software => true,
          :has_registered_downloads => true,
          :has_online_retailers => true,
          :has_distributors => true,
          :has_dealers => true,
          :has_service_centers => true)
      elsif brand.name.match(/bss/i)
        brand.update_attributes(
          :has_effects => false, 
          :has_reviews => true, 
          :has_faqs => true, 
          :has_tone_library => false,
          :has_artists => false,
          :has_clinics => false,
          :has_software => true,
          :has_registered_downloads => false,
          :has_online_retailers => true,
          :has_distributors => true,
          :has_dealers => true,
          :has_service_centers => true)
      elsif brand.name.match(/jbl/i)
        brand.update_attributes(
          :has_effects => false, 
          :has_reviews => false, 
          :has_faqs => false, 
          :has_tone_library => false,
          :has_artists => false,
          :has_clinics => false,
          :has_software => false,
          :has_registered_downloads => false,
          :has_online_retailers => false,
          :has_distributors => true,
          :has_dealers => true,
          :has_service_centers => false)
      end
    end
  end

  def self.down
    remove_column :brands, :has_service_centers
    remove_column :brands, :has_dealers
    remove_column :brands, :has_distributors
    remove_column :brands, :has_online_retailers
    remove_column :brands, :has_registered_downloads
    remove_column :brands, :has_software
    remove_column :brands, :has_clinics
    remove_column :brands, :has_artists
    remove_column :brands, :has_tone_library
    remove_column :brands, :has_faqs
    remove_column :brands, :has_reviews
    remove_column :brands, :has_effects
  end
end