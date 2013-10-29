class ProductIntroduction < ActiveRecord::Base
  belongs_to :product
  attr_accessible :content, :expires_on, :extra_css, :layout_class, :product_id, :top_image, :box_bg_image, :page_bg_image
  validates :product_id, presence: true
  has_attached_file :top_image
  has_attached_file :box_bg_image
  has_attached_file :page_bg_image

  def expired?
  	self.expires_on ||= 1.week.from_now
  	!!(self.expires_on.to_date <= Date.today)
  end
end
