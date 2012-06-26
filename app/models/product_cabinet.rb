class ProductCabinet < ActiveRecord::Base
  belongs_to :product
  belongs_to :cabinet
  validates_presence_of :product_id, :cabinet_id
  validates_uniqueness_of :cabinet_id, :scope => :product_id
end
