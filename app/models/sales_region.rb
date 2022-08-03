class SalesRegion < ApplicationRecord
  belongs_to :brand
  has_many :sales_region_countries

  validates :name, presence: true, uniqueness: { scope: :brand, case_sensitive: false }
end
