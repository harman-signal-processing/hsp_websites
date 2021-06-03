class CustomShopQuoteLineItem < ApplicationRecord
  # had to shorten related id to be able to generate database index
  has_many :custom_shop_quote_line_item_attributes, foreign_key: 'line_item_id', dependent: :destroy
  has_many :customizable_attributes, -> { distinct }, through: :custom_shop_quote_line_item_attributes
  belongs_to :product
  belongs_to :custom_shop_quote

  validates :product, presence: true
  validates :custom_shop_quote, presence: true

  accepts_nested_attributes_for :custom_shop_quote_line_item_attributes, reject_if: :all_blank

  after_initialize :build_options

  def build_options
    if product
      product.customizable_attributes.each do |ca|
        unless customizable_attributes.include?(ca)
          custom_shop_quote_line_item_attributes << CustomShopQuoteLineItemAttribute.new(customizable_attribute: ca)
        end
      end
    end
  end

end
