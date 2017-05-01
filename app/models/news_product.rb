class NewsProduct < ApplicationRecord
  belongs_to :news, touch: true
  belongs_to :product, touch: true

  validates :news_id, presence: true
  validates :product_id, presence: true, uniqueness: { scope: :news_id }
end
