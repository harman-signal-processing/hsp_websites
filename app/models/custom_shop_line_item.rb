class CustomShopLineItem < ApplicationRecord
  has_many :custom_shop_line_item_attributes, dependent: :destroy
  has_many :customizable_attributes, -> { distinct }, through: :custom_shop_line_item_attributes
  belongs_to :product
  belongs_to :custom_shop_quote
  belongs_to :custom_shop_cart

  validates :product, presence: true
  validates :custom_shop_cart, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  monetize :price_cents, allow_nil: true
  accepts_nested_attributes_for :custom_shop_line_item_attributes, reject_if: :all_blank

  after_initialize :set_defaults

  def build_options
    if product
      product.customizable_attributes.each do |ca|
        unless customizable_attributes.include?(ca)
          custom_shop_line_item_attributes << CustomShopLineItemAttribute.new(customizable_attribute: ca)
        end
      end
    end
  end

  def set_defaults
    self.quantity ||= 1
  end

  def subtotal
    if self.price
      self.quantity * self.price
    else
      0
    end
  end

end
