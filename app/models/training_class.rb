class TrainingClass < ApplicationRecord
  has_many :product_training_classes, dependent: :destroy
  has_many :products, through: :product_training_classes
  has_many :software_training_classes, dependent: :destroy
  has_many :softwares, through: :software_training_classes
  has_many :training_class_registrations
  belongs_to :instructor, class_name: "User", foreign_key: "instructor_id", optional: true
  belongs_to :training_course
  validates :location, presence: true

  def name
    @name ||= "#{training_course.name} - #{location}"
  end
end
