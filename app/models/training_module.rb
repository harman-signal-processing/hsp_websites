class TrainingModule < ActiveRecord::Base
  has_many :product_training_modules, :dependent => :destroy
  has_many :products, :through => :product_training_modules
  has_many :software_training_modules, :dependent => :destroy
  has_many :softwares, :through => :software_training_modules
  belongs_to :brand
  validates :brand_id, :name, :presence => true
  has_attached_file :training_module

end
