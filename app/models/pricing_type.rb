class PricingType < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :brand_id }
  belongs_to :brand
end
