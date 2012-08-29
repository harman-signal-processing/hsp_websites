class ProductIntroduction < ActiveRecord::Base
  belongs_to :product
  attr_accessible :content, :expires_on, :extra_css, :layout_class, :product_id
  validates :product_id, presence: true

  def expired?
  	self.expires_on ||= 1.week.from_now
  	!!(self.expires_on.to_date <= Date.today)
  end
end
