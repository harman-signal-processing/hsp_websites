class MarketSegmentProductFamily < ActiveRecord::Base
  belongs_to :market_segment
  belongs_to :product_family
  acts_as_list :scope => :market_segment_id
  validates :market_segment_id, :presence => true
  validates :product_family_id, :presence => true, :uniqueness => {:scope => :market_segment_id}
end
