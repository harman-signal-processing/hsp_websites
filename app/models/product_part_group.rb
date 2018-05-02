class ProductPartGroup < ApplicationRecord
  belongs_to :product

  has_many :product_part_group_parts
  has_many :parts, through: :product_part_group_parts

  validates :name, presence: true

  acts_as_tree
end
