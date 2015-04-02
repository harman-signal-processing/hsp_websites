class BrandDealer < ActiveRecord::Base
  belongs_to :brand
  belongs_to :dealer
  validates :brand_id, presence: true
  validates :dealer_id, presence: true, uniqueness: { scope: :brand_id }
end
