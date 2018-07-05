class SalesRegion < ApplicationRecord
  belongs_to :brand
  has_many :sales_region_countries

  validates :brand, presence: true
  validates :name, presence: true, uniqueness: { scope: :brand }
end
