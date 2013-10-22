class TrainingModule < ActiveRecord::Base
  has_many :product_training_modules, dependent: :destroy
  has_many :products, through: :product_training_modules
  has_many :software_training_modules, dependent: :destroy
  has_many :softwares, through: :software_training_modules
  belongs_to :brand
  validates :brand_id, :name, presence: true
  has_attached_file :training_module,
    path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    url: ":asset_host/system/:attachment/:id_:timestamp/:basename_:style.:extension"

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
