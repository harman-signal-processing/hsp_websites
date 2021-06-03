class CustomShopQuote < ApplicationRecord
  has_many :custom_shop_quote_line_items, dependent: :destroy
  belongs_to :user
  before_create :set_uuid

  #validates :user, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.request_delivery_on ||= 6.months.from_now.to_date
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def recipients
    brand.custom_shop_email
  end

  def brand
    begin
      custom_shop_quote_line_items.first.product.brand
    rescue
      Brand.new
    end
  end
end
