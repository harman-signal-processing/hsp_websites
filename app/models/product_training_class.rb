class ProductTrainingClass < ApplicationRecord
  belongs_to :training_class, touch: true
  belongs_to :product, touch: true
  validates :training_class_id, uniqueness: {scope: :product_id}
end
