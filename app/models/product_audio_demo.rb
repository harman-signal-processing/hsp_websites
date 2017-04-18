class ProductAudioDemo < ApplicationRecord
  belongs_to :audio_demo
  belongs_to :product, touch: true
  validates :audio_demo_id, presence: true, uniqueness: { scope: :product_id }
  validates :product_id, presence: true
end
