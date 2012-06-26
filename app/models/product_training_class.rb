class ProductTrainingClass < ActiveRecord::Base
  belongs_to :training_class
  belongs_to :product
  validates :product_id, :presence => true
  validates :training_class_id, :presence => true, :uniqueness => {:scope => :product_id}
end
