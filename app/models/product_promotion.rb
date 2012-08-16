class ProductPromotion < ActiveRecord::Base
  belongs_to :product, touch: true
  belongs_to :promotion, touch: true
  validates_presence_of :product_id, :promotion_id
  validates_uniqueness_of :product_id, scope: :promotion_id
end
