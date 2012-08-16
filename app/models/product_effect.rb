class ProductEffect < ActiveRecord::Base
  belongs_to :product, touch: true
  belongs_to :effect
  validates_presence_of :product_id, :effect_id
  validates_uniqueness_of :effect_id, scope: :product_id
end
