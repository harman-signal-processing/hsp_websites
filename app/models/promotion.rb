class Promotion < ApplicationRecord
  include Rails.application.routes.url_helpers
  extend FriendlyId
  friendly_id :sanitized_name

  attribute :show_recalculated_price, :boolean, default: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :product_promotions, inverse_of: :promotion
  has_many :products, through: :product_promotions
  belongs_to :brand, touch: true
  belongs_to :banner, class_name: "Setting", foreign_key: "banner_id", optional: true

  has_attached_file :promo_form
  do_not_validate_attachment_file_type :promo_form

  has_attached_file :tile,
    styles: { large: "550x370",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      tiny: "64x64",
      tiny_square: "64x64#"
    }
  validates_attachment :tile, content_type: { content_type: /\Aimage/i }

  has_attached_file :homepage_banner, {
    styles: { banner: "840x390",
      large: "550x370",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      tiny: "64x64",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression] }
  validates_attachment :homepage_banner, content_type: { content_type: /\Aimage/i }

  process_in_background :tile
  process_in_background :homepage_banner

  accepts_nested_attributes_for :product_promotions, reject_if: proc { |p| p["product_id"].blank? }, allow_destroy: true
  accepts_nested_attributes_for :banner, reject_if: :all_blank
  before_validation :update_banner

  def sanitized_name
    self.name.gsub(/[\'\"]/, "")
  end

  # All promotions for the given Website whose start/end range
  # is still current.
  #
  def self.current(website)
    website.brand.promotions.where(["start_on IS NOT NULL AND end_on IS NOT NULL AND start_on <= ? AND end_on >= ?", Date.today, Date.today])
  end

  # Sorted collection of self.current
  #
  def self.all_for_website(website)
    current(website).order("end_on ASC")
  end

  # All CURRENT promotions (those which are not expired) for the given Website
  #
  def self.current_for_website(website)
    website.brand.promotions.where(["start_on IS NOT NULL AND start_on <= ? AND (end_on >= ? OR end_on IS NULL or length(end_on) = 0)", Date.today, Date.today]).order("end_on ASC")
  end

  def update_banner
    if banner && banner.slide_file_name.present?
      banner.setting_type = "slideshow frame"
      banner.start_on = self.start_on
      banner.remove_on = self.end_on
      banner.name = "#{self.name} Banner"
      banner.string_value = best_landing_page_path
      banner.brand_id = self.brand_id
    end
  end

  def best_landing_page_path
    if product_promotions.length == 1
      product_path(product_promotions.first.product, locale: I18n.locale)
    elsif common_product_family
      product_family_path(common_product_family, locale: I18n.locale)
    else
      promotion_path(self, locale: I18n.locale)
    end
  end

  def common_product_family
    product_promotions.map do |pp|
      pp.product.product_families
    end.reduce(:&).first
  end

  # !blank? doesn't work because tiny MCE supplies a blank line even
  # if we don't want it...
  def has_description?
    self.description.size > 28
  end

  def expired?
    (end_on.present? && end_on <= Date.today)
  end

end
