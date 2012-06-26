class ProductPromotion < ActiveRecord::Base
  belongs_to :product
  belongs_to :promotion
  validates_presence_of :product_id, :promotion_id
  validates_uniqueness_of :product_id, :scope => :promotion_id
end
