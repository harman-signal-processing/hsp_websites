class ProductVideo < ApplicationRecord
  include YoutubeVideo
  belongs_to :product, touch: true, inverse_of: :product_videos

  validates :youtube_id,
    presence: true,
    format: { without: /http/i, message: "must be the ID only (not a URL)" }
  validates :group, presence: true

  acts_as_list scope: :product
  before_validation :sanitize_youtube_id, :set_default_group

  protected

  def set_default_group
    self.group = "Product Videos" if self.group.blank?
  end

  def sanitize_youtube_id
    #self.youtube_id = "1234"
    if self.youtube_id.to_s.match?(/^http/)
      if self.youtube_id.match(/v\=(.*)$/)
        self.youtube_id = $1
      end
    end
  end
end
