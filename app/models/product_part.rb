class ProductPart < ApplicationRecord
  belongs_to :product
  belongs_to :part

  acts_as_tree

end
