class SalesOrder < ApplicationRecord

  belongs_to :shopping_cart
  belongs_to :user
  belongs_to :address
  has_many :line_items

  validates :user, presence: true
  validates :address, presence: true

  after_create :assign_line_items, :send_confirmation

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
    line_items.map{|li| li.product.product_type_id}.include?( ProductType.digital_ecom.id )
  end

  def transaction_id
    if self.shopping_cart.payment_data.present?
      self.shopping_cart.payment_data["pspReference"]
    end
  end

  def status
    if self.shopping_cart.payment_data.present?
      self.shopping_cart.payment_data["resultCode"]
    end
  end

  private

  # Here we assign an available product key to the order's line items and to the user
  # We may need to figure out a way to reserve them earlier in the process
  def assign_line_items
    self.shopping_cart.line_items.each do |li|
      li.update(sales_order: self)
    end
  end

  def send_confirmation
    EcommerceMailer.with(sales_order: self).order_confirmation.deliver_later
  end

end
