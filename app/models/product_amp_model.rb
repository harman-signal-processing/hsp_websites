class ProductAmpModel < ActiveRecord::Base
  belongs_to :product
  belongs_to :amp_model
  validates_presence_of :product_id, :amp_model_id
  validates_uniqueness_of :amp_model_id, :scope => :product_id
end
