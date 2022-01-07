class ProductVideo < ApplicationRecord
  include YoutubeVideo
  belongs_to :product, touch: true, inverse_of: :product_videos

  validates :product, presence: true
  validates :youtube_id,
    presence: true,
    format: { without: /http/i, message: "must be the ID only (not a URL)" }
  validates :group, presence: true

  acts_as_list scope: :product
  before_validation :set_default_group

  def set_default_group
    self.group ||= "Product Videos"
  end

end
