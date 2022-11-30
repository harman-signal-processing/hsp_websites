class ProductFamilyVideo < ApplicationRecord
  include YoutubeVideo
  belongs_to :product_family, touch: true, inverse_of: :product_family_videos

  validates :youtube_id,
    presence: true,
    format: { without: /http/i, message: "must be the ID only (not a URL)" }

  acts_as_list scope: :product_family

  before_validation :sanitize_youtube_id

  protected

  def sanitize_youtube_id
    if youtube_id.to_s.match?(/^http/)
      if youtube_id.match(/v\=(.*)$/)
        self.youtube_id = $1
      end
    end
  end
end
