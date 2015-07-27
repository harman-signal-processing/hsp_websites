class OnlineRetailerLink < ActiveRecord::Base
  belongs_to :online_retailer, touch: true
  belongs_to :brand
  belongs_to :product, touch: true

  validates :online_retailer_id, presence: true
  validates :url, presence: true

  before_update :reset_status
  before_save :stamp_link, :fix_link
  after_update :auto_delete

  def self.to_be_checked
    gc = OnlineRetailer.find_by(name: "Guitar Center")
    where(["link_checked_at <= ? OR link_checked_at IS NULL", 5.days.ago])
      .includes(:online_retailer)
      .where("online_retailers.active" => true)
      .where("online_retailers.id <> ?", gc.id)
      .order("link_checked_at ASC")
  end

  def self.problems
    where("link_status != '200'")
  end

  def stamp_link
    self.link_checked_at ||= Time.now
  end

  def fix_link
    unless !!(self.url.match(/^http/))
      self.link = "http://#{self.url}"
    end
  end

  def reset_status
    self.link_status = '200' if self.url_changed?
  end

  # get rid of this link if the related product is discontinued
  def auto_delete
    if self.link_status != '200' && self.product && self.product.discontinued?
      self.destroy
    end
  end

  def expanded_name
    if self.product
      tag = self.product.name
    elsif self.brand
      tag = self.brand.name
    else
      tag = ""
    end
    "#{self.online_retailer.name}: #{tag}"
  end
end
