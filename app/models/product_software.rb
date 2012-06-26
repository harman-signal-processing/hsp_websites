class ProductSoftware < ActiveRecord::Base
  belongs_to :product
  belongs_to :software
  validates_presence_of :product_id, :software_id
  validates_uniqueness_of :software_id, :scope => :product_id
end
