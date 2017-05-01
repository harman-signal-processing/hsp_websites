class ProductVideo < ApplicationRecord
  belongs_to :product, touch: true

  validates :product, presence: true
  validates :youtube_id, presence: true
  validates :group, presence: true

  acts_as_list scope: :product

end
