class CustomShopQuote < ApplicationRecord
  has_many :custom_shop_line_items, dependent: :destroy
  belongs_to :user
  belongs_to :custom_shop_cart

  validates :user, presence: true
  validates :custom_shop_cart, presence: true

  after_initialize :set_defaults
  after_create :assign_line_items, :send_request

  accepts_nested_attributes_for :custom_shop_line_items

  ransack_alias :attributes, :opportunity_number_or_opportunity_name_or_location_or_account_number_or_user_name_or_user_email

  def set_defaults
    self.request_delivery_on ||= 6.months.from_now.to_date
    self.status ||= "new"
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

  def number
    brand.name[0,3].upcase + "CS" + created_at.year.to_s[2,2] + id.to_s.rjust(5, "0")
  end

  def total
    custom_shop_line_items.inject(0){|t,i| t += i.subtotal}
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
