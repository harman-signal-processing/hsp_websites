class ProductAudioDemo < ApplicationRecord
  belongs_to :audio_demo
  belongs_to :product, touch: true
  validates :audio_demo_id, uniqueness: { scope: :product_id, case_sensitive: false }
end
