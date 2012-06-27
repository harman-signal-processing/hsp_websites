class MarketSegment < ActiveRecord::Base
  belongs_to :brand, touch: true
  has_many :market_segment_product_families, :order => :position, :dependent => :destroy
  has_many :product_families, :through => :market_segment_product_families
  validates :name, :presence => true
  validates :brand_id, :presence => true
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, :max_length => 100
end
