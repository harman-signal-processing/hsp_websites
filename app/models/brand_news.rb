class BrandNews < ApplicationRecord
  belongs_to :brand, touch: true
  belongs_to :news
  validates :news, presence: true, uniqueness: { scope: :brand_id, case_sensitive: false }
  validates :brand, presence: true
end
