class ProductReviewProduct < ActiveRecord::Base
  belongs_to :product_review
  belongs_to :product
  
end
