class Brand < ActiveRecord::Base
  has_many :product_families
  has_many :market_segments
  has_many :online_retailer_links, order: "RAND()", conditions: "actve = 1"
  has_many :dealers
  has_many :news
  has_many :pages
  has_many :promotions
  has_many :service_centers
  has_many :softwares
  has_many :artist_brands
  has_many :artists, through: :artist_brands
  has_many :warranty_registrations
  has_many :brand_distributors
  has_many :distributors, through: :brand_distributors
  has_many :websites
  has_many :settings
  has_many :site_elements
  has_many :training_modules
  has_many :training_classes
  has_many :blogs
  # RSO stuff
  has_many :rso_monthly_reports
  has_many :rso_navigations, order: :position
  has_many :rso_panels
  has_many :rso_pages
  has_many :tweets, order: "posted_at DESC"
  has_attached_file :logo, 
    styles: { large: "640x480", 
      medium: "480x360", 
      small: "240x180",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    },
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  after_initialize :dynamic_methods
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  validates_presence_of :name

  def news
    News.find_by_sql("SELECT DISTINCT news.* FROM news
      INNER JOIN news_products ON news_products.news_id = news.id
      INNER JOIN products ON products.id = news_products.product_id
      INNER JOIN product_family_products ON product_family_products.product_id = products.id
      INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
      WHERE product_families.brand_id = #{self.id} OR news.brand_id = #{self.id}
      ORDER BY post_on DESC")
    # News.select("DISTINCT news.*").joins("INNER JOIN news_products ON news_products.news_id = news.id").joins("INNER JOIN products ON products.id = news_products.product_id").joins("INNER JOIN product_family_products ON product_family_products.product_id = products.id").joins("INNER JOIN product_families ON product_families.id = product_family_products.product_family_id").where("product_families.brand_id = ? OR news.brand_id = ?", self.id, self.id)
  end
  
  # Dynamically create methods based on this Brand's settings.
  # This is a smarter alternative to using method_missing
  def dynamic_methods
    self.settings.each do |meth|
      (class << self; self; end).class_eval do
        define_method meth.name.to_sym do |*args|
          self.__send__("value_for", meth.name, *args)
        end
      end
    end
  end

  # This should work as a dynamic method, but mailers have troubles
  def support_email
    begin
      self.settings.where(name: "support_email").value
    rescue
      ""
    end
  end
  
  # Those brands which should be included on the RSO site. This could
  # be controlled dynamically by a db field...later.
  def self.for_rso
    # find_all_by_name(["BSS", "dbx", "Lexicon", "JBL Commercial", "DigiTech"])
    [
      find_by_name("BSS"), 
      find_by_name("dbx"), 
      find_by_name("Lexicon"),
      find_by_name("JBL Commercial"),
      find_by_name("DigiTech")
    ]
  end
    
  def has_where_to_buy?
    !!(self.has_online_retailers? || self.has_dealers? || self.has_distributors?)
  end
  
  def default_website
    if !self.default_website_id.blank?
      Website.find(self.default_website_id)
    else
      self.websites.first
    end
  end
  
  def default_website=(website)
    self.default_website_id = website.id
  end

  def self.pull_tweets
    all.each{|b| b.pull_tweets if b.twitter_name}
  end
  
  def pull_tweets
    Tweet.pull_tweets(self)
  end

  def recent_tweets(num=6)
    tweets.limit(num)
  end

  def twitter_name
    begin
      if self.twitter && tw = self.twitter.match(/(\w*)$/).to_s 
        tw
      else
        false
      end
    rescue
      false
    end
  end

  def current_news
    News.all_for_website(self.default_website)
  end

  def current_products
    p = []
    product_families.each do |pf|
      p += pf.current_products
    end
    p.uniq #.flatten.uniq.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end
    
  def family_products
    p = []
    product_families.each do |pf|
      p += pf.products
    end
    p.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end
  
  def products
    p = Product.where(brand_id: self.id).all
    p += self.family_products
    p.uniq.sort{|a,b| a.name.downcase <=> b.name.downcase}
    # Product.find_by_sql("SELECT DISTINCT products.* FROM products
    #   INNER JOIN product_family_products ON product_family_products.product_id = products.id
    #   INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
    #   WHERE products.brand_id = #{self.id} OR product_families.brand_id = #{self.id}").sort{|a,b| a.name.downcase <=> b.name.downcase}
  end
  
  def value_for(key, locale=I18n.locale)
    s = self.settings.where(name: key)
    setting = s.where(["locale IS NULL OR locale = ?", locale]).first
    unless locale == I18n.default_locale # don't look for translation
      s1 = s.where(locale: locale)
      if s1.all.size > 0
        setting = s1.first
      elsif parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false # "es-MX" => "es"
        s2 = s.where(locale: parent_locale)
        if s2.all.size > 0
          setting = s2.first
        end
      end
    end
    (setting) ? setting.value : nil
  end
  
  # The default side tabs to show on product pages. This can be overridden
  # with a setting named side_tabs which is a pipe-separated list of tabs
  def side_tabs
    default_tabs = "features|specifications|documentation|training_modules|downloads|artists|tones|news_and_reviews|support"
    tabs = self.value_for("side_tabs") || default_tabs
    tabs.split("|")
  end
  
  def main_tabs
    default_tabs = "description|extended_description|features|specifications"
    tabs = self.value_for("main_tabs") || default_tabs
    tabs.split("|")
  end
  
  def admin_actions(num_days=365)
    AdminLog.where(website_id: self.websites.collect{|w| w.id}).where("created_at > ?", num_days.days.ago)
  end
end
