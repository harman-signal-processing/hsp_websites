class ProductSuggestion < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :suggested_product, class_name: "Product", foreign_key: "suggested_product_id"
  acts_as_list scope: :product
  validates :product_id, presence: true
  validates :suggested_product_id, presence: true, uniqueness: {scope: :product_id}
end
