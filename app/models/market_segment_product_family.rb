class MarketSegmentProductFamily < ApplicationRecord
  belongs_to :market_segment, touch: true
  belongs_to :product_family, touch: true
  acts_as_list scope: :market_segment_id
  validates :product_family_id, uniqueness: {scope: :market_segment_id}
end
