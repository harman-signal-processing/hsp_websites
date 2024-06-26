class ProductFamilyProduct < ApplicationRecord
  belongs_to :product_family, touch: true, counter_cache: true, inverse_of: :product_family_products
  belongs_to :product, touch: true
  acts_as_list scope: :product_family_id
  validates :product_id, uniqueness: { scope: :product_family_id, case_sensitive: false }

  after_commit :update_counts

  def update_counts
    self.product_family.update_current_product_counts if self.product_family.present?
  end
end
