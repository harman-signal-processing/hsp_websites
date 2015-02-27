class MarketSegment < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  belongs_to :brand, touch: true
  has_many :market_segment_product_families, -> { order('position') }, dependent: :destroy
  has_many :product_families, through: :market_segment_product_families
  has_attached_file :banner_image, { styles: { medium: "300x300>", thumb: "100x100>" }}.merge(S3_STORAGE)

  validates_attachment :banner_image, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true
  validates :brand_id, presence: true

  after_save :translate

  # Translates this record into other languages.
  def translate
    ContentTranslation.auto_translate(self, self.brand)
  end
  handle_asynchronously :translate

  def self.with_current_products(website, locale)
    segments = []
    where(brand_id: website.brand_id).each do |ms|
      segments << ms if ms.product_families_with_current_products.length > 0
    end
    segments
  end

  def product_families_with_current_products
    product_families.select{|pf| pf if pf.current_products.length > 0 }
  end

end
