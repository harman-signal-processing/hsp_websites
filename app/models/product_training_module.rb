class ProductTrainingModule < ActiveRecord::Base
  belongs_to :training_module, touch: true
  belongs_to :product, touch: true
  validates :product_id, :presence => true
  validates :training_module_id, :presence => true, :uniqueness => {:scope => :product_id}
  acts_as_list :scope => :product
end
