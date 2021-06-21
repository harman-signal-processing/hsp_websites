class BrandDealerRentalProduct < ApplicationRecord
  belongs_to :brand_dealer
  belongs_to :product
  validates :brand_dealer_id, presence: true
  validates :product_id, presence: true, uniqueness: { scope: :brand_dealer_id }
end  #  class BrandDealerRentalProduct < ApplicationRecord
