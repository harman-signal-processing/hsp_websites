class ProductSuggestion < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :suggested_product, class_name: "Product", foreign_key: "suggested_product_id"
  acts_as_list scope: :product
  validates :suggested_product_id, uniqueness: {scope: :product_id}
end
