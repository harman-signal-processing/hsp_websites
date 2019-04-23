# Someday it will be nice to automate this. Here is a sample api query
# to the Google Blogger API
#
# https://www.googleapis.com/blogger/v3/blogs/6859338560143857989/posts/search?q=crown&key=api-key
#
# Need to authenticate first in order to use it
#
class News < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  acts_as_taggable
  scope :by_post_date, -> { order("post_on DESC") }
  scope :active, -> { where("post_on <= ?", Date.today) }

  has_attached_file :news_photo, {
    styles: {
      banner: "1500>x400",
      large: "600>x370",
      email: "580",
      medium: "350x350>",
      small: "240",
      small_square: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }, default_url: "harman-logo.png"
  }.merge(S3_STORAGE)
  validates_attachment :news_photo, content_type: { content_type: /\Aimage/i }

  belongs_to :brand, touch: true
  has_many :news_products, dependent: :destroy
  has_many :products, through: :news_products
  has_many :news_images, dependent: :destroy

  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"

  validates :brand_id, presence: true
  validates :title, presence: true
  validates :post_on, presence: true

  before_save :strip_harmans_from_title
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
      [:brand_name, :title],
      [:brand_name, :title, :created_at]
    ]
  end

  def brand_name
    self.brand.name
  end

  def should_generate_new_friendly_id?
    true
  end

  # News to display on the main area of the site. This set of news articles
  # includes entries from the past year and a half.
  def self.all_for_website(website, options={})

    # First, select news story IDs with a product associated with this brand...
    product_news = News.find_by_sql("SELECT DISTINCT news.id, news.post_on FROM news
      INNER JOIN news_products ON news_products.news_id = news.id
      INNER JOIN products ON products.id = news_products.product_id
      INNER JOIN product_family_products ON product_family_products.product_id = products.id
      INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
      WHERE product_families.brand_id = #{website.brand_id}
      AND post_on >= '#{120.months.ago}' AND post_on <= '#{Date.today}'
      ORDER BY post_on").collect{|p| p.id}.join(", ")
    product_news_query = (product_news.blank?) ? "" : " OR id IN (#{product_news}) "

    # Second, add in those stories associated with the brand only (no products linked)
    select("DISTINCT *").where("(brand_id = ? AND post_on >= ? AND post_on <= ?) #{product_news_query}", website.brand_id, 120.months.ago, Date.today).order(Arel.sql("post_on DESC"))
  end

  # Older news for the archived page. These are articles older than 1.5 year.
  def self.archived(website)
    # First, select news story IDs with a product associated with this brand...
    product_news = News.find_by_sql("SELECT DISTINCT news.id, news.post_on FROM news
      INNER JOIN news_products ON news_products.news_id = news.id
      INNER JOIN products ON products.id = news_products.product_id
      INNER JOIN product_family_products ON product_family_products.product_id = products.id
      INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
      WHERE product_families.brand_id = #{website.brand_id}
      AND post_on <= '#{120.months.ago}'
      ORDER BY post_on DESC").collect{|p| p.id}.join(", ")
    product_news_query = (product_news.blank?) ? "" : " OR id IN (#{product_news}) "

    # Second, add in those stories associated with the brand only (no products linked)
    select("DISTINCT *").where("(brand_id = ? AND post_on <= ?) #{product_news_query}", website.brand_id, 120.months.ago).order("post_on DESC")
  end

  # Alias for search results link name
  def link_name
    self.send(:link_name_method)
  end

  def link_name_method
    :title
  end

  # Alias for search results content preview
  def content_preview
    "#{I18n.l(self.created_at.to_date, format: :long)} - #{self.body}"
  end

  def content_preview_method
    :body
  end

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
