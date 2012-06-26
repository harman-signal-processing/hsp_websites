class ProductTrainingModule < ActiveRecord::Base
  belongs_to :training_module
  belongs_to :product
  validates :product_id, :presence => true
  validates :training_module_id, :presence => true, :uniqueness => {:scope => :product_id}
  acts_as_list :scope => :product
end
