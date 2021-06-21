class BrandDealer < ApplicationRecord
  belongs_to :brand
  belongs_to :dealer
  validates :brand_id, presence: true
  validates :dealer_id, presence: true, uniqueness: { scope: :brand_id, case_sensitive: false }

  has_many :brand_dealer_rental_products, dependent: :destroy
end
