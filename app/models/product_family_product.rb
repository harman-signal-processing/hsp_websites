class ProductFamilyProduct < ActiveRecord::Base
  belongs_to :product_family, touch: true
  belongs_to :product, touch: true
  acts_as_list scope: :product_family_id
  validates_presence_of :product_family_id, :product_id
  validates_uniqueness_of :product_id, scope: :product_family_id
end
