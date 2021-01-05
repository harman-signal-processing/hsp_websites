class SalesOrder < ApplicationRecord

  belongs_to :user
  belongs_to :shopping_cart
  has_many :line_items
  validates :user, presence: true

  after_create :assign_line_items

  # Format an official looking order number
  # First 3 characters of brand name, 1 zero, 2-digit year, order id padded with up to 5 zeros
  def number
    brand.name[0,3].upcase + "0" + created_at.year.to_s[2,2] + id.to_s.rjust(5, "0")
  end

  def brand
    line_items.first.product.brand
  end

  def tax
    shopping_cart.tax
  end

  def total
    shopping_cart.total
  end

  def has_digital_downloads?
    true
  end

  private

  # Here we assign an available product key to the order's line items and to the user
  # We may need to figure out a way to reserve them earlier in the process
  def assign_line_items
    self.shopping_cart.line_items.each do |li|
      li.update(sales_order: self)
    end
  end

end
