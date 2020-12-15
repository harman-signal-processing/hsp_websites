class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :shopping_cart
  monetize :price_cents

  validates :product, presence: true, uniqueness: { scope: :shopping_cart_id }
  validates :shopping_cart, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.quantity ||= 1
    if self.product
      self.price = product.price_for_shopping_cart
    end
  end

  def subtotal
    self.quantity * self.price
  end

  def increment
    update(quantity: quantity + 1)
  end

end
