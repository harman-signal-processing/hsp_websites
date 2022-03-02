class ProductFilter < ApplicationRecord
  has_many :product_family_product_filters, dependent: :destroy
  has_many :product_families, through: :product_family_product_filters
  has_many :product_product_filter_values, dependent: :destroy
  has_many :products, through: :product_product_filter_values

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :value_type, presence: true

  scope :not_associated_with_this_product_family, -> (product_family) {
    ids_already_associated = ProductFamilyProductFilter.where(product_family: product_family).pluck(:product_filter_id)
    unscoped.where.not(id: ids_already_associated)
  }

  def self.value_types
    [
      [ "Yes/No", "boolean"],
      [ "Text", "string"],
      [ "Numeric (slide down)", "number"],
      [ "Numeric (slide up)", "number_upwards"],
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

  def unique_values_for(product_family, website)
    product_filter_values_for(product_family, website).map do |ppfv|
      ppfv.value
    end.uniq
  end

  def product_filter_values_for(product_family, website)
    product_family_product_ids = product_family.current_products_plus_child_products(website).pluck(:id)
    product_product_filter_values.where(product_id: product_family_product_ids)
  end

  # Determine the minimum value for the given product family
  def min_value_for(product_family, website)
    min_range_for(product_family, website).first
  end

  def min_range_for(product_family, website)
    rangify unique_values_for(product_family, website).map { |v| v.to_s.split(/-/).first.to_i }
  end

  # Determine the maximum value for the given product family
  def max_value_for(product_family, website)
    max_range_for(product_family, website).last
  end

  def max_range_for(product_family, website)
    range = rangify unique_values_for(product_family, website).map { |v| v.to_s.split(/-/).last.to_i }
    alt_min = min_range_for(product_family, website).last
    range[0] = alt_min if alt_min > range[0]
    range
  end

  # Determine the best stepsize for the given product family
  def stepsize_for(product_family, website)
    begin
      min = min_value_for(product_family, website)
      max = max_value_for(product_family, website)
      range = max - min
      steps = (stepsize.present? && stepsize > 0) ? range / stepsize : 0
      (steps >= 10) ? stepsize : ((range+1) / 10).to_i
    rescue
      stepsize.present? ? stepsize : 1
    end
  end

  def fallback_min
    (min_value.present? ? min_value : 0).to_i
  end

  def fallback_max
    (max_value.present? ? max_value : 0).to_i
  end

  private

  def rangify(values)
    begin
      values.sort!
      range = [rounddown(values.first.to_i), roundup(values.last.to_i)]
      spread = range.last - range.first
      (spread > (stepsize * 2) + 1) ? range : [fallback_min, fallback_max]
    rescue
      [fallback_min, fallback_max]
    end
  end

  def roundup(num)
    digits = num.digits.length
    exp = case
    when digits > 4
      digits - 2
    when digits > 1
      digits - 1
    else
      1
    end
    step = 10**exp
    whole, remainder = num.divmod(step)
    num_steps = remainder > 0 ? whole + 1 : whole
    num_steps * step
  end

  def rounddown(num)
    digits = num.digits.length
    exp = case
    when digits > 4
      digits - 2
    when digits > 1
      digits - 1
    else
      1
    end
    (num / (10.0**exp)).floor * (10**exp)
  end
end
