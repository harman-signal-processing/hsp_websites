class Specification < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  belongs_to :specification_group
  has_many :product_specifications
  validates :name, presence: true, uniqueness: true

  acts_as_list scope: :specification_group_id

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
