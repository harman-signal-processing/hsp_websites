class ProductFamilyVideo < ApplicationRecord
  belongs_to :product_family, touch: true

  validates :product_family, presence: true
  validates :youtube_id, presence: true

  acts_as_list scope: :product_family

  def url
    "https://www.youtube.com/embed/#{youtube_id}"
  end
end
