class ProductAmpModel < ActiveRecord::Base
  belongs_to :product, touch: true
  belongs_to :amp_model
  validates :product_id, presence: true
  validates :amp_model_id, presence: true, uniqueness: { scope: :product_id }
end
