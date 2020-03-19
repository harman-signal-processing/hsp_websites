class ProductProductFilterValue < ApplicationRecord
  belongs_to :product_filter
  belongs_to :product

  validates :product, presence: true
  validates :product_filter, presence: true, uniqueness: { scope: :product }

  def value
    self.send "#{self.product_filter.value_type}_value"
  end

  # The range value is stored in the text input field
  def range_value
    string_value
  end
end
