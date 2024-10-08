class Specification < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  belongs_to :specification_group, optional: true
  has_many :product_specifications, inverse_of: :specification
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :specification_group_id }

  acts_as_list scope: :specification_group_id
  after_save :reset_options_for_select

  accepts_nested_attributes_for :product_specifications, reject_if: proc { |attr| attr['value'].blank? }

  scope :not_for_brand_comparison, -> (brand) {
    unscoped.where.not(id: brand.specification_for_comparisons.pluck(:specification_id)).order("name")
  }

  # Adding the class variable causes options_for_select to be cached
  def self.options_for_select
    @options_for_select ||= order(:name)
  end

  # Don't worry, this just sets up options_for_select to get re-cached next time it's needed
  def self.reset_options_for_select
    @options_for_select = nil
  end

  # If something changed, we need to reset our cached dropdown options_for_select
  def reset_options_for_select
    Specification.reset_options_for_select
  end

  def values_with_products
    r = {}
    product_specifications.find_each do |product_specification|
      r[product_specification.value] ||= []
      r[product_specification.value] << product_specification.product
    end
    r
  end

  def name_with_group
    specification_group.present? ? "#{name} (#{specification_group.name})" : name
  end

  def self.weight_specs
    where("name LIKE '%weight%'").where.not("name LIKE '%ship%'").where.not("name LIKE '%weighted%'")
  end

  def self.shipping_weight_specs
    where("name LIKE '%weight%'").where("name LIKE '%ship%'")
  end

  def self.dimensions_specs
    where("name LIKE '%dimension%'").where.not("name LIKE '%ship%'")
  end

  def self.shipping_dimensions_specs
    where("name LIKE '%dimension%'").where("name LIKE '%ship%'")
  end
end
