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
  has_many :pricing_types, order: :pricelist_order
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
  after_update :update_products
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  validates_presence_of :name

  def update_products
    begin
    if live_on_this_platform_changed? && live_on_this_platform?
      self.products.each do |p|
        p.more_info_url = nil
        p.save 
      end
    end
    rescue
      # oh well.
    end
  end

  def news
    # First, select news story IDs with a product associated with this brand...
    product_news = News.find_by_sql("SELECT DISTINCT news.id FROM news
      INNER JOIN news_products ON news_products.news_id = news.id
      INNER JOIN products ON products.id = news_products.product_id
      INNER JOIN product_family_products ON product_family_products.product_id = products.id
      INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
      WHERE product_families.brand_id = #{self.id}
      ORDER BY post_on DESC").collect{|p| p.id}.join(", ")
    product_news_query = (product_news.blank?) ? "" : " OR id IN (#{product_news}) "

    # Second, add in those stories associated with the brand only (no products linked)
    News.select("DISTINCT *").where("brand_id = ? #{product_news_query}", self.id).order("post_on DESC")
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
      "support@harman.com"
    end
  end
  
  # Those brands which should be included on the RSO site. This could
  # be controlled dynamically by a db field...later.
  def self.for_rso
    where(name: ["BSS", "dbx", "Lexicon", "JBL Commercial", "DigiTech"])
  end

  # Those brands which should appear on the myharman.com store (via the API)
  def self.for_employee_store
    where(employee_store: true).order("UPPER(name)") || where(name: ["DigiTech", "Lexicon", "dbx", "DOD"])
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
    fp = self.family_products.collect{|p| p.id}.join(', ')
    if fp.blank?
      Product.where(brand_id: self.id).order("UPPER(name)")
    else
      Product.select("DISTINCT *").where("brand_id = ? OR id IN (#{fp})", self.id).order("UPPER(name)")
    end
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

  # For the api, picks a slideshow banner.
  def api_banner_url
    begin
      if default = self.value_for("api_banner_url")
        default
      else
        slides = Setting.slides(self.default_website)
        if slides.size > 1
          slides.sample.slide.url(:original, false)
        else
          nil
        end
      end
    rescue
      ""
    end
  end

  # Collects data for the pricelist
  def pricelist(website, locale)
    io = StringIO.new
    book = Spreadsheet::Workbook.new
    bold = Spreadsheet::Format.new weight: :bold, size: 10, horizontal_align: :center
    bold_left = Spreadsheet::Format.new weight: :bold, size: 10, horizontal_align: :left
    spacer = Spreadsheet::Format.new top: :thick
    subheader = Spreadsheet::Format.new weight: :bold, size: 16
    subheader_right = Spreadsheet::Format.new weight: :bold, size: 16, horizontal_align: :right
    sheet = book.create_worksheet name: "#{self.name} Pricelist"
    sheet.column(0).width = 14
    sheet.column(1).width = 40
    sheet.column(2).width = 12
    sheet.column(3).width = 12

    row_index = 1
    row = sheet.row(row_index)
    row.height = 20
    row.default_format = subheader
    row.push self.name
    row.push ""
    row.push ""
    row.push ""
    row.push "US Dealer"
    sheet.rows[row_index].set_format(4, subheader_right)

    row_index += 1
    row = sheet.row(row_index)
    row.height = 20
    row.default_format = subheader
    row.push ""
    row.push ""
    row.push ""
    row.push ""
    row.push "Confidential Pricelist"
    sheet.rows[row_index].set_format(4, subheader_right)

    row_index += 2
    header = sheet.row(row_index)
    header.height = 15
    header.push "Effective #{I18n.l Date.today, format: :long}"
    header.push ""
    header.push "MSRP (US$)"
    header.push "MAP (US$)"
    sheet.rows[row_index].set_format(0, bold_left)
    # pricing_types = pricing_types.where("pricelist_order > 0").order("pricelist_order")
    pricing_types.each_with_index do |pricing_type, i|
      unless pricing_type.pricelist_order.to_i <= 0
        header.push "#{pricing_type.name} (US$)"
        sheet.column(4 + i).width = 12
      end
    end
    header.default_format = bold
    row_index +=1

    ProductFamily.parents_with_current_products(website, locale).each do |product_family|
      spacer_row = sheet.row(row_index)
      spacer_row.default_format = spacer
      5.times { spacer_row.push "" }
      row_index += 1
      row = sheet.row(row_index)
      row.height = 18
      row.default_format = subheader
      row.push << product_family.name

      product_family.current_products_plus_child_products(website).each do |product|
        if !(product.discontinued?) && product.show_on_website?(website) && product.can_be_registered?
          row_index += 1
          row = sheet.row(row_index)
          row.push (product.sap_sku.present?) ? product.sap_sku : product.name 
          row.push product.short_description
          row.push product.msrp
          row.push product.street_price
          pricing_types.each do |pricing_type|
            unless pricing_type.pricelist_order.to_i <= 0
              pr = product.price_for(pricing_type).to_f
              row.push (pr.to_f > 0.0) ? pr : ""
            end
          end
        end
      end
      row_index += 1
    end

    book.write(io)
    io.string
  end

end
