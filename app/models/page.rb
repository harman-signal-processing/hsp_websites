class Page < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true 
  validates :brand_id, presence: true
  validates :custom_route, uniqueness: true 
  has_friendly_id :sanitized_title, use_slug: true, approximate_ascii: true, max_length: 100
  belongs_to :brand
  after_save :translate
  
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

  # Translates this record into other languages. 
  def translate
    unless self.body.size > 65000 # large pages cause delayed job problems
      ContentTranslation.auto_translate(self, self.brand)
    end
  end
  handle_asynchronously :translate
  
end
