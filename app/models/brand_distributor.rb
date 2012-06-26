class BrandDistributor < ActiveRecord::Base
  belongs_to :brand
  belongs_to :distributor
  validates_presence_of :brand_id, :distributor_id
  validates_uniqueness_of :distributor_id, :scope => :brand_id
end
