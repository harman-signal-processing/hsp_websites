class ProductTrainingModule < ApplicationRecord
  belongs_to :training_module, touch: true
  belongs_to :product, touch: true
  validates :training_module_id, uniqueness: {scope: :product_id}
  acts_as_list scope: :product
end
