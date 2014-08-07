class ProductFamilyProduct < ActiveRecord::Base
  belongs_to :product_family, touch: true
  belongs_to :product, touch: true
  acts_as_list scope: :product_family_id
  validates :product_family_id, presence: true
  validates :product_id, presence: true, uniqueness: { scope: :product_family_id }
end
