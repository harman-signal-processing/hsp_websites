class Page < ActiveRecord::Base
  validates_presence_of :title, :brand_id
  validates_uniqueness_of :title
  validates_uniqueness_of :custom_route, allow_nil: true
  has_friendly_id :sanitized_title, use_slug: true, approximate_ascii: true, max_length: 100
  belongs_to :brand

  define_index do
    indexes :title
    indexes :keywords
    indexes :description
    indexes :body
    indexes :custom_route
  end
  
  def sanitized_title
    self.title.gsub(/[\'\"]/, "")
  end
  
  def self.all_for_website(website)
    where(brand_id: website.brand_id).all    
  end

  # Alias for search results link_name
  def link_name
    self.title
  end
  
  # Alias for search results content_preview
  def content_preview
    self.body
  end

  # Checks if this page requires a username and password:
  def requires_login?
    !!!(self.username.blank? && self.password.blank?)
  end
  
  # Figure out if a field is protected to avoid config errors
  def disable_field?(attribute)
    value = eval("self.#{attribute.to_s}")
    if attribute == :custom_route
      return false if value.blank?
      !!(brand.settings.where("name LIKE '%url%' AND string_value LIKE '%#{value}%'").count > 0)
    end
  end
  
end
