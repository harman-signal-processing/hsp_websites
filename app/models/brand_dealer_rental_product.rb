class BrandDealerRentalProduct < ApplicationRecord
  belongs_to :brand_dealer
  belongs_to :product
  validates :product_id, uniqueness: { scope: :brand_dealer_id }
end  #  class BrandDealerRentalProduct < ApplicationRecord
