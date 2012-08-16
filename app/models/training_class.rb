class TrainingClass < ActiveRecord::Base
  has_many :product_training_classes, dependent: :destroy
  has_many :products, through: :product_training_classes
  has_many :software_training_classes, dependent: :destroy
  has_many :softwares, through: :software_training_classes
  belongs_to :instructor, class_name: "User", foreign_key: "instructor_id"
  belongs_to :brand
  validates :brand_id, :name, :instructor_id, presence: true
  
end
