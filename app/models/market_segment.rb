class MarketSegment < ActiveRecord::Base
  belongs_to :brand, touch: true
  has_many :market_segment_product_families, order: :position, dependent: :destroy
  has_many :product_families, through: :market_segment_product_families
  validates :name, presence: true
  validates :brand_id, presence: true
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  after_save :translate

  # Translates this record into other languages. 
  def translate
    ContentTranslation.auto_translate(self, self.brand)
  end
  handle_asynchronously :translate
end
