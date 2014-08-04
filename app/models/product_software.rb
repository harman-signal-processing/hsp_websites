class ProductSoftware < ActiveRecord::Base
  default_scope { order("software_position") }
  belongs_to :product, touch: true
  belongs_to :software, touch: true
  validates_presence_of :product_id, :software_id
  validates_uniqueness_of :software_id, scope: :product_id
end
