# Someday it will be nice to automate this. Here is a sample api query
# to the Google Blogger API
#
# https://www.googleapis.com/blogger/v3/blogs/6859338560143857989/posts/search?q=crown&key=api-key
#
# Need to authenticate first in order to use it
#
class News < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_attached_file :news_photo, {
    styles: { large: "600>x370",
      email: "580",
      medium: "350x350>",
      small: "240",
      small_square: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }}.merge(S3_STORAGE)
  validates_attachment :news_photo, content_type: { content_type: /\Aimage/i }

  has_many :news_products, dependent: :destroy
  has_many :products, through: :news_products
  belongs_to :brand, touch: true

  validates :brand_id, presence: true
  validates :title, presence: true
  validates :post_on, presence: true

  before_save :strip_harmans_from_title
  after_save :translate
  attr_accessor :from, :to

  # When presenting the site to Rob before going live, he asked that we remove
  # the the word "HARMAN's" from the beginning of the news titles.
  def strip_harmans_from_title
    self.title.gsub!(/^HARMAN.s/, "")
    self.title.gsub!(/^\s*/, "")
  end

  def sanitized_title
    self.title.gsub(/[\'\"]/, "")
  end

  def slug_candidates
    [
      :title,
      [:brand_id, :title],
      [:brand_id, :title, :created_at]
    ]
  end

  # News to display on the main area of the site. This set of news articles
  # includes entries from the past year and a half.
  def self.all_for_website(website, options={})

    # If the website specifies a limit for the number of news entries for the homepage,
    # then we'll show that amount to the 3rd power on the actual news page.
    if website.homepage_news_limit.to_i > 0
      options[:limit] ||= website.homepage_news_limit.to_i ** 3
    end
    limit = (options[:limit]) ? " LIMIT #{options[:limit]} " : ""

    # First, select news story IDs with a product associated with this brand...
    product_news = News.find_by_sql("SELECT DISTINCT news.id FROM news
      INNER JOIN news_products ON news_products.news_id = news.id
      INNER JOIN products ON products.id = news_products.product_id
      INNER JOIN product_family_products ON product_family_products.product_id = products.id
      INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
      WHERE product_families.brand_id = #{website.brand_id}
      AND post_on >= '#{18.months.ago}' AND post_on <= '#{Date.today}'
      ORDER BY post_on DESC #{limit}").collect{|p| p.id}.join(", ")
    product_news_query = (product_news.blank?) ? "" : " OR id IN (#{product_news}) "

    # Second, add in those stories associated with the brand only (no products linked)
    select("DISTINCT *").where("(brand_id = ? AND post_on >= ? AND post_on <= ?) #{product_news_query}", website.brand_id, 18.months.ago, Date.today).order("post_on DESC #{limit}")
  end

  # Older news for the archived page. These are articles older than 1.5 year.
  def self.archived(website)
    # First, select news story IDs with a product associated with this brand...
    product_news = News.find_by_sql("SELECT DISTINCT news.id FROM news
      INNER JOIN news_products ON news_products.news_id = news.id
      INNER JOIN products ON products.id = news_products.product_id
      INNER JOIN product_family_products ON product_family_products.product_id = products.id
      INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
      WHERE product_families.brand_id = #{website.brand_id}
      AND post_on <= '#{18.months.ago}'
      ORDER BY post_on DESC").collect{|p| p.id}.join(", ")
    product_news_query = (product_news.blank?) ? "" : " OR id IN (#{product_news}) "

    # Second, add in those stories associated with the brand only (no products linked)
    select("DISTINCT *").where("(brand_id = ? AND post_on <= ?) #{product_news_query}", website.brand_id, 18.months.ago).order("post_on DESC")
  end

  # Alias for search results link name
  def link_name
    self.title
  end

  # Alias for search results content preview
  def content_preview
    "#{I18n.l(self.created_at.to_date, format: :long)} - #{self.body}"
  end

  def quote_or_headline
    @quote_or_headline ||= self.quote.present? ? self.quote : self.title
  end

  # Translates this record into other languages.
  def translate
    ContentTranslation.auto_translate(self, self.brand)
  end
  handle_asynchronously :translate

  def notify(options={})
    default_options = { from: 'support@digitech.com', to: 'config.hpro_execs' }
    options = default_options.merge options
    if options[:to].to_s.match(/\@/)
      SiteMailer.delay.news(self, options[:to], options[:from])
    elsif options[:to].to_s.match(/^config/)
      list = eval("HarmanSignalProcessingWebsite::Application.#{options[:to]}")
      list.each{ |executive| SiteMailer.delay.news(self, executive, options[:from]) }
    end
  end

end
