class Vip::Website < ApplicationRecord
  before_save :fix_url_format
	validates :url, presence: true
	
	has_many :programmer_websites, dependent: :destroy, foreign_key: "vip_website_id"
	has_many :programmers, through: :programmer_websites
	
    
  # If the url doesn't have http:// in front, then add it.
  def fix_url_format
    if !self.url.blank? && !self.url.match(/^http/i)
      self.url = "http://#{self.url}"
    end
  end	
	
end
