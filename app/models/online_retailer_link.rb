class OnlineRetailerLink < ActiveRecord::Base
  belongs_to :online_retailer
  belongs_to :brand
  belongs_to :product
  validates_presence_of :online_retailer_id, :url
  before_update :reset_status
  before_save :stamp_link
  
  def self.to_be_checked
    where(["link_checked_at <= ? OR link_checked_at IS NULL", 5.days.ago]).order("link_checked_at ASC")
  end
  
  def self.problems
    where("link_status != '200'")
  end
  
  def stamp_link
    self.link_checked_at ||= Time.now
  end
  
  def reset_status
    self.link_status = '200' if self.url_changed?
  end
end
