class SpecificationGroup < ApplicationRecord
  has_many :specifications
  validates :name, presence: true

  def specifications_for(product)
    specifications.where(id: product.product_specifications.map{|ps| ps.specification_id})
  end
end
