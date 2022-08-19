class NewsProduct < ApplicationRecord
  belongs_to :news, touch: true
  belongs_to :product, touch: true

  validates :product_id, uniqueness: { scope: :news_id, case_sensitive: false }
end
