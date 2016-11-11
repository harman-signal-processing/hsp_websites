class ProductSolution < ActiveRecord::Base
  belongs_to :product
  belongs_to :solution
end
