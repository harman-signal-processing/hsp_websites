class ManufacturerPartner < ApplicationRecord
  belongs_to :site_element
  before_save :fix_url_format
    
  # If the url doesn't have http:// in front, then add it.
  def fix_url_format
    if !self.url.blank? && !self.url.match(/^http/i)
      self.url = "http://#{self.url}"
    end
  end
    
end