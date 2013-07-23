class NewsProduct < ActiveRecord::Base
  belongs_to :news, touch: true
  belongs_to :product, touch: true

  validate :news_id, presence: true
  validate :product_id, presence: true, uniqueness: { scope: :news_id }
end
