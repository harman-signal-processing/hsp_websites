class TrainingModule < ApplicationRecord
  has_many :product_training_modules, dependent: :destroy
  has_many :products, through: :product_training_modules
  has_many :software_training_modules, dependent: :destroy
  has_many :softwares, through: :software_training_modules
  belongs_to :brand
  validates :brand_id, :name, presence: true
  has_attached_file :training_module, S3_STORAGE
  validates_attachment :training_module #, presence: true
  do_not_validate_attachment_file_type :training_module

  def self.modules_for(brand_id, options={})
  	collection = select("DISTINCT training_modules.*").where(brand_id: brand_id)
  	if options[:module_type]
  		collection = collection.joins("#{options[:module_type]}_training_modules".to_sym)
  	end
  	collection
  end

  def active_softwares
    self.softwares.where(active: true)
  end
end
