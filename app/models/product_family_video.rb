class ProductFamilyVideo < ApplicationRecord
  include YoutubeVideo
  belongs_to :product_family, touch: true, inverse_of: :product_family_videos

  validates :product_family, presence: true
  validates :youtube_id, presence: true

  acts_as_list scope: :product_family

end
