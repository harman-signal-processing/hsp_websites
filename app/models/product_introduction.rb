class ProductIntroduction < ApplicationRecord
  belongs_to :product

  has_attached_file :top_image
  has_attached_file :box_bg_image
  has_attached_file :page_bg_image

  validates_attachment :top_image, content_type: { content_type: /\Aimage/i }
  validates_attachment :box_bg_image, content_type: { content_type: /\Aimage/i }
  validates_attachment :page_bg_image, content_type: { content_type: /\Aimage/i }

  def expired?
  	self.expires_on ||= 1.week.from_now
  	!!(self.expires_on.to_date <= Date.today)
  end
end
