class News < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  acts_as_taggable

  has_attached_file :news_photo, {
    styles: {
      banner: ["1500>x400", :webp],
      large: ["600>x370", :webp],
      email: "580",
      medium_square: "480x480#",
      medium: "480x480>",
      small: "240",
      small_square: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression],
    convert_options: {
      banner: "-define webp:lossless=true ",
      large: "-define webp:lossless=true "
    }, default_url: "news_photo.jpg"
  }
  validates_attachment :news_photo, content_type: { content_type: /\Aimage/i }

  has_attached_file :square, {
    styles: {
      banner: ["1500>x400", :webp],
      large: ["600>x370", :webp],
      email: "580",
      medium_square: "480x480#",
      medium: "480x480>",
      small: "240",
      small_square: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression],
    convert_options: {
      banner: "-define webp:lossless=true ",
      large: "-define webp:lossless=true "
    }, default_url: "news_photo.jpg"
  }
  validates_attachment :square, content_type: { content_type: /\Aimage/i }

  alias_attribute :name, :title

  has_many :brand_news, dependent: :destroy
  has_many :brands, through: :brand_news
  has_many :news_products, dependent: :destroy
  has_many :products, through: :news_products
  has_many :news_images, dependent: :destroy

  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"
  has_many :media_translations, as: :translatable, foreign_key: "media_id", foreign_type: "media_type"

  validates :title, presence: true
  validates :post_on, presence: true

  before_save :strip_harmans_from_title
  attr_accessor :from, :to

  scope :product_news, ->(website, options) {
    unscoped.select("DISTINCT news.id, news.post_on").
      joins("INNER JOIN news_products ON news_products.news_id = news.id").
      joins("INNER JOIN products ON products.id = news_products.product_id").
      joins("INNER JOIN product_family_products ON product_family_products.product_id = products.id").
      joins("INNER JOIN product_families ON product_families.id = product_family_products.product_family_id").
      where("post_on > ?", options[:start_on]).
      where("post_on <= ?", options[:end_on]).
      where("product_families.brand_id = ?", website.brand_id ).
      order("post_on DESC")
  }

  scope :query_for_website, ->(website, options) {
    rel = unscoped.select("DISTINCT news.*").
      joins("INNER JOIN brand_news ON brand_news.news_id = news.id").
      where("brand_news.brand_id = ?  #{product_news_query(website, options)}", website.brand_id).
      where("post_on >= ? AND post_on <= ?", options[:start_on], options[:end_on]).
      order("post_on DESC")
    options[:limit].present? ? rel.limit(options[:limit]) : rel
  }


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
    brands.pluck(:name).join(", ")
  end

  def belongs_to_this_brand?(website)
    !!brands.pluck(:id).include?(website.brand_id)
  end

  def should_generate_new_friendly_id?
    true
  end

  def self.all_for_website(website, options={})
    default_options = { start_on: 120.months.ago, end_on: Date.today }
    query_for_website(website, default_options.merge(options))
  end

  # Older news for the archived page.
  def self.archived(website, options={})
    default_options = { start_on: 99.years.ago, end_on: 120.months.ago }
    query_for_website(website, default_options.merge(options))
  end

  def self.product_news_query(website, options)
    unless options[:skip_product_news_query]
      product_news_ids = product_news(website, options).pluck("news.id").join(", ")
      (product_news_ids.blank?) ? "" : " OR news.id IN (#{product_news_ids}) "
    end
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

  def other_locales_with_translations(website)
    all_locales_with_translations(website) - [I18n.locale.to_s]
  end

  def all_locales_with_translations(website)
    content_translations.pluck(:locale).uniq + ["en", "en-US"]
  end

  def hreflangs(website)
    all_locales_with_translations(website)
  end
end
