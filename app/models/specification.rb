class Specification < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  belongs_to :specification_group
  has_many :product_specifications, inverse_of: :specification
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  acts_as_list scope: :specification_group_id

  scope :not_for_brand_comparison, -> (brand) {
    unscoped.where.not(id: brand.specification_for_comparisons.pluck(:specification_id)).order("name")
  }

  def self.options_for_select
    @options_for_select ||= order(:name)
  end

  def values_with_products
    r = {}
    product_specifications.each do |product_specification|
      r[product_specification.value] ||= []
      r[product_specification.value] << product_specification.product
    end
    r
  end

  def name_with_group
    specification_group.present? ? "#{name} (#{specification_group.name})" : name
  end

end
