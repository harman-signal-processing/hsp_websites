class PricingType < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :brand_id, case_sensitive: false }
  belongs_to :brand
end
