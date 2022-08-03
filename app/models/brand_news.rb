class BrandNews < ApplicationRecord
  belongs_to :brand, touch: true
  belongs_to :news
  validates :news, uniqueness: { scope: :brand_id, case_sensitive: false }
end
