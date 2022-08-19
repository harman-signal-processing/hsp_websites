class ProductProductFilterValue < ApplicationRecord
  belongs_to :product_filter
  belongs_to :product

  validates :product_filter, uniqueness: { scope: :product, case_sensitive: false }

  def value
    self.send "#{self.product_filter.value_type}_value"
  end

  # The range value is stored in the text input field
  def range_value
    string_value
  end

  def number_upwards_value
    number_value
  end
end
