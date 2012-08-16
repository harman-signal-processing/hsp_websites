class ProductSoftware < ActiveRecord::Base
  belongs_to :product, touch: true
  belongs_to :software, touch: true
  validates_presence_of :product_id, :software_id
  validates_uniqueness_of :software_id, scope: :product_id
end
