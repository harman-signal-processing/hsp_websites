class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :shopping_cart
  belongs_to :sales_order
  has_many :product_keys
  monetize :price_cents

  validates :product, presence: true, uniqueness: { scope: :shopping_cart_id }
  validates :shopping_cart, presence: true

  after_initialize :set_defaults
  before_save :assign_product_keys

  def set_defaults
    self.quantity ||= 1
    if self.product
      self.price = product.price_for_shopping_cart
    end
  end

  def subtotal
    self.quantity * self.price
  end

  private

  def assign_product_keys
    if self.sales_order.present? && self.product.digital_ecom?
      product.available_product_keys[0,quantity.to_i].each do |k|
        k.update(
          user: sales_order.user,
          line_item: self
        )
      end
    end
  end

end
