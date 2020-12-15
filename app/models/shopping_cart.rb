class ShoppingCart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_item(product)
    current_line_item = line_items.find_by(product_id: product.id)

    if current_line_item
      current_line_item.increment
    else
      current_line_item = LineItem.create!(product_id: product.id, shopping_cart: self)
    end
  end

  def empty?
    !(line_items.length > 0)
  end

  def subtotal
    line_items.inject(0.0){|t,i| t += i.subtotal}
  end

end
