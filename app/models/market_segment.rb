class MarketSegment < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates

  belongs_to :brand, touch: true
  has_many :market_segment_product_families, -> { order('position') }, dependent: :destroy
  has_many :product_families, through: :market_segment_product_families
  has_attached_file :banner_image, {
    styles: {
      banner: "1024x300",
      large: "640x480",
      medium: "300x300>",
      horiz_medium: "670x275",
      vert_medium: "375x400",
      medium_small: "150x225",
      small: "240x180",
      horiz_thumb: "170x80",
      thumb: "100x100>",
      tiny: "64x64",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression] }

  validates_attachment :banner_image, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true

  acts_as_tree order: :position, scope: :brand_id, touch: true

  def slug_candidates
    [
      :name,
      [:brand_name, :name],
      [:brand_name, :name, :id]
    ]
  end

  def brand_name
    self.brand.name
  end

  def should_generate_new_friendly_id?
    true
  end

  # All top-level MarketSegments
  #  w = a Brand or a Website
  def self.all_parents(w)
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    where(brand_id: brand_id).where(parent_id: nil).order(:position)
  end

  def self.with_current_products
    segments = []
    where(brand_id: website.brand_id).order(:created_at).each do |ms|
      segments << ms if ms.product_families_with_current_products.length > 0
    end
    segments
  end

  def self.with_current_products(website, locale)
    segments = []
    where(brand_id: website.brand_id).order(:created_at).each do |ms|
      segments << ms if ms.product_families_with_current_products(website,locale).length > 0
    end
    segments
  end

  def product_families_with_current_products
    product_families.select{|pf| pf if pf.current_products.length > 0 }
  end

  def product_families_with_current_products(website,locale)
    product_families.select{|pf|
      if pf.current_products_plus_child_products(website, { depth: 1 }).length > 0
        ms_pf = MarketSegmentProductFamily.where(market_segment_id: self.id, product_family_id: pf.id)
        pf.position = ms_pf.first.position
        pf
      end
    }
  end

  def all_current_products(website, locale)
    @all_current_products ||= self.product_families_with_current_products(website,locale).map{|pf| pf.current_products}.flatten.uniq
  end

  def related_news(website,locale)
    @related_news ||= self.all_current_products(website,locale).map{|p| p.current_news}.flatten.uniq
  end

end
