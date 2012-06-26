class Setting < ActiveRecord::Base
  before_save :fix_locale  
  has_attached_file :slide,
    :styles => { :large => "600>x370", 
      :medium => "350x350>", 
      :thumb => "100x100>", 
      :tiny => "64x64>", 
      :tiny_square => "64x64#" 
    }
  belongs_to :brand
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:locale, :brand_id]
  
  def self.setting_types
    ["string", "integer", "text", "slideshow frame", "homepage feature"]
  end

  # Collect all Settings which are designated as 'slideshow frame' for the homepage.
  # Note: the integer_value is used for the position, and the string_value is used
  # to hyperlink when the frame is displayed. Now with I18n. (See #value)   
  def self.slides(website)
    s = where(:brand_id => website.brand_id).where(:setting_type => "slideshow frame").where("slide_file_name IS NOT NULL").order(:integer_value)
    defaults = s.where(["locale IS NULL or locale = ?", I18n.locale])
    locale_slides = nil
    unless I18n.locale == I18n.default_locale # don't look for translation
      s1 = s.where(["locale = ?", I18n.locale]) # try "foo_es-MX" (for example)
      if s1.all.size > 0
        locale_slides = s1
      elsif parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false # "es-MX" => "es"
  	    s2 = s.where(["locale = ?", parent_locale]) # try "foo_es"
  	    if s2.all.size > 0
  	      locale_slides = s2
        end
      end
    end
    (locale_slides) ? locale_slides : defaults
  end
  
  # Collect all Settings which are homepage features
  def self.features(website)
    where(:brand_id => website.brand_id).where(:setting_type => "homepage feature").where("slide_file_name IS NOT NULL").order(:integer_value)
  end
  
  # Wrapper to grab the site name
  def self.site_name(website)
    begin
      where(:brand_id => website.brand_id).where(:name => "site_name").first.value
    rescue
      SITE_NAME
    end
  end
  
  # Wrapper to grab a value_for('some_setting_name'). Now with I18n support.
  # Settings names should have something in the "locale" field: 
  #  "" => default setting for all locales unless an alternate is provided
  #  "es" => spanish setting for "foo"
  #  "es-MX" => spanish-mexico setting for "foo"
  #
  # def self.value_for(key='foo', brand_id, locale=I18n.locale)
  #   s = where(:name => key).where(:brand_id => brand_id)
  #   setting = s.where(["locale IS NULL OR locale = ?", locale]).first
  #   unless locale == I18n.default_locale # don't look for translation
  #     s1 = s.where(:locale => locale)
  #     if s1.all.size > 0
  #       setting = s1.first
  #     elsif parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false # "es-MX" => "es"
  #       s2 = s.where(:locale => parent_locale)
  #       if s2.all.size > 0
  #         setting = s2.first
  #       end
  #     end
  #   end
  #   (setting) ? setting.value : nil
  # end
  
  def fix_locale
    if self.locale.blank?
      self.locale = nil
    end
  end

  # Determines the value of the current Setting. Values can come
  # from the string, text, integer, or slide attachment. 
  def value(locale=I18n.locale)
    begin
      (self.setting_type =~ /slide/) ? self.slide : eval("self.#{self.setting_type}_value")
    rescue
      nil
    end
  end
  
end
