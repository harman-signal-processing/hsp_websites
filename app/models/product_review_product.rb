class ProductReviewProduct < ActiveRecord::Base
  belongs_to :product_review, touch: true
  belongs_to :product, touch: true
  
end
