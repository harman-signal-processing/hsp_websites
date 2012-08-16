class ProductTrainingClass < ActiveRecord::Base
  belongs_to :training_class, touch: true
  belongs_to :product, touch: true
  validates :product_id, presence: true
  validates :training_class_id, presence: true, uniqueness: {scope: :product_id}
end
