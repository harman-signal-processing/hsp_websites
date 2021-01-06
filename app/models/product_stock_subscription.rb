class ProductStockSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user, presence: true
  validates :product, presence: true
  validates :low_stock_level, presence: true

  def notify
    EcommerceMailer.with(product_stock_subscription: self).low_stock.deliver_later
  end
end
