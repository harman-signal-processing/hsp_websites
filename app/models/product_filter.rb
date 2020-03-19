class ProductFilter < ApplicationRecord
  has_many :product_family_product_filters
  has_many :product_families, through: :product_family_product_filters
  has_many :product_product_filter_values
  has_many :products, through: :product_product_filter_values

  validates :name, presence: true, uniqueness: true
  validates :value_type, presence: true

  scope :not_associated_with_this_product_family, -> (product_family) {
    ids_already_associated = ProductFamilyProductFilter.where(product_family: product_family).pluck(:product_filter_id)
    ProductFilter.where.not(id: ids_already_associated)
  }

  def self.value_types
    [
      [ "Yes/No", "boolean"],
      [ "Text", "string"],
      [ "Numeric", "number"],
      [ "Range", "range"]
    ]
  end

  def is_boolean?
    (self.value_type.to_s.match?(/boolean/i))
  end

  def is_string?
    (self.value_type.to_s.match?(/string/i))
  end

  def is_number?
    (self.value_type.to_s.match?(/number/i))
  end

  def is_range?
    (self.value_type.to_s.match?(/range/i))
  end

  def unique_values_for(product_family)
    product_filter_values_for(product_family).map do |ppfv|
      ppfv.value
    end.uniq
  end

  def product_filter_values_for(product_family)
    product_product_filter_values.select do |ppfv|
      ppfv if ppfv.product.root_product_families.include?(product_family)
    end
  end
end
