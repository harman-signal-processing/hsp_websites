class ProductFilter < ApplicationRecord
  has_many :product_family_product_filters, dependent: :destroy
  has_many :product_families, through: :product_family_product_filters
  has_many :product_product_filter_values, dependent: :destroy
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
    product_product_filter_values.includes(:product).select do |ppfv|
      ppfv if ppfv.product.product_family_tree.pluck(:id).include?(product_family.id)
    end
  end

  # Determine the minimum value for the given product family
  def min_value_for(product_family)
    begin
      m = unique_values_for(product_family).map do |v|
        v.to_s.split(/-/).first.to_i
      end.sort.first.to_i - stepsize.to_i
      (m < fallback_min) ? fallback_min : m
    rescue
      fallback_min
    end
  end

  # Determine the maximum value for the given product family
  def max_value_for(product_family)
    begin
      m = unique_values_for(product_family).map do |v|
        v.to_s.split(/-/).last.to_i
      end.sort.last.to_i
      m = roundup(m)
      (m > fallback_max) ? fallback_max : m
    rescue
      fallback_max
    end
  end

  def fallback_min
    (min_value.present? ? min_value : 0).to_i
  end

  def fallback_max
    (max_value.present? ? max_value : 0).to_i
  end

  private

  def roundup(num)
    exp = (num.digits.length > 1) ? (num.digits.length - 1) : 1
    step = 10**exp
    whole, remainder = num.divmod(step)
    num_steps = remainder > 0 ? whole + 1 : whole
    num_steps * step
  end

end
