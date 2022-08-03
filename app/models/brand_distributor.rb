class BrandDistributor < ApplicationRecord
  belongs_to :brand
  belongs_to :distributor, touch: true
  validates :distributor_id, uniqueness: { scope: :brand_id, case_sensitive: false }
end
