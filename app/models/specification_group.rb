class SpecificationGroup < ApplicationRecord
  has_many :specifications
  validates :name, presence: true
  acts_as_list

  accepts_nested_attributes_for :specifications, reject_if: proc { |attr| attr[:name].blank? }

  def specifications_for(product)
    specifications.where(id: product.product_specifications.map{|ps| ps.specification_id})
  end
end
