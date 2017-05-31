class Specification < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  belongs_to :product_specification
  has_many :product_specifications
  validates :name, presence: true, uniqueness: true

  def values_with_products
    r = {}
    product_specifications.each do |product_specification|
      r[product_specification.value] ||= []
      r[product_specification.value] << product_specification.product
    end
    r
  end

end
