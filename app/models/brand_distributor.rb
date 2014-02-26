class BrandDistributor < ActiveRecord::Base
  belongs_to :brand
  belongs_to :distributor, touch: true
  validates :brand_id, presence: true
  validates :distributor_id, presence: true, uniqueness: { scope: :brand_id }
end
