class ProductKey < ApplicationRecord

  validates :key, presence: true, uniqueness: { case_sensitive: false }

  belongs_to :product
  belongs_to :line_item # if purchased
  belongs_to :user # if purchased

  before_update :evaluate_stock_level

  def sales_order
    if line_item_id.present? && line_item.sales_order_id.present?
      self.line_item.sales_order
    else
      nil
    end
  end

  def formatted_key
    key.scan(/..../).join("-").upcase
  end

  private

  def evaluate_stock_level
    if line_item_id_changed?
      ProductStockSubscription.where(product_id: product_id).where("low_stock_level <= ?", product.available_product_keys.length).each do |pss|
        pss.notify
      end
    end
  end
end
