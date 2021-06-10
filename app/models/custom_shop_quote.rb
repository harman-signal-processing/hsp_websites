class CustomShopQuote < ApplicationRecord
  has_many :custom_shop_line_items, dependent: :destroy
  belongs_to :user
  belongs_to :custom_shop_cart

  validates :user, presence: true
  validates :custom_shop_cart, presence: true

  after_initialize :set_defaults
  after_create :assign_line_items, :send_request

  def set_defaults
    self.request_delivery_on ||= 6.months.from_now.to_date
  end

  def recipients
    brand.custom_shop_email
  end

  def brand
    begin
      custom_shop_line_items.first.product.brand
    rescue
      Brand.new
    end
  end

  private

  def assign_line_items
    self.custom_shop_cart.custom_shop_line_items.each do |li|
      li.update(custom_shop_quote: self)
    end
  end

  def send_request
    CustomShopMailer.delay.request_quote(self)
  end

end
