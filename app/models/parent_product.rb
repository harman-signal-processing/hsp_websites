class ParentProduct < ActiveRecord::Base
  attr_accessible :parent_product_id, :position, :product_id
  belongs_to :parent_product, class_name: "Product", foreign_key: "parent_product_id"
  belongs_to :product, touch: true # the child
  acts_as_list scope: :parent_product_id
end
