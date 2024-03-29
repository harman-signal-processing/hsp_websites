class SalesRegionCountry < ApplicationRecord
  belongs_to :sales_region

  validates :name, presence: true, uniqueness: { scope: :sales_region, case_sensitive: false  }
end
