class Vip::Website < ApplicationRecord
  before_save :fix_url_format
	validates :url, presence: true
	
	has_many :programmer_websites, dependent: :destroy, foreign_key: "vip_website_id"
	has_many :programmers, through: :programmer_websites
	
  scope :not_associated_with_this_programmer, -> (programmer) { 
    website_ids_already_associated_with_this_programmer = Vip::ProgrammerWebsite.where("vip_programmer_id = ?", programmer.id).map{|programmer_website| programmer_website.vip_website_id }
    websites_not_associated_with_this_programmer = self.where.not(id: website_ids_already_associated_with_this_programmer)    
    websites_not_associated_with_this_programmer
  }	
    
  # If the url doesn't have http:// in front, then add it.
  def fix_url_format
    if !self.url.blank? && !self.url.match(/^http/i)
      self.url = "http://#{self.url}"
    end
  end	
	
end
