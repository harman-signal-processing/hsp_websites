class ProductPart < ApplicationRecord
  belongs_to :product
  belongs_to :part

  validates :part, presence: true
  validates :product, presence: true

  acts_as_tree

end
