class OnlineRetailer < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  has_many :online_retailer_users, dependent: :destroy
  has_many :users, through: :online_retailer_users
  has_many :online_retailer_links, -> { where("product_id IS NOT NULL") }, dependent: :destroy
  has_attached_file :retailer_logo,
    styles: {
      medium: "300x300>",
      small: "175x175>",
      thumb: "100x100>",
      fixed: "125x75#"
    }

  validates_attachment :retailer_logo, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  attr_accessor :brand_link, :online_retailer_link, :brand_sort_order

  def bad_links
    @bad_links ||= OnlineRetailerLink.problems.where(online_retailer_id: self.id)
  end

  # Adds a User to be able to maintain this OnlineRetailer
  def add_user(user=User.new)
    if !user.new_record?
      OnlineRetailerUser.where(online_retailer_id: self.id, user_id: user.id).first_or_create
    end
  end

  # Retrieves a randomized list of OnlineRetailers who have a brand_link defined
  def self.random(website)
    preferred(website) + random_without_preferred(website)
  end

  def self.preferred(website)
    where(active: true).where("preferred > 0").select(
      "online_retailers.*, online_retailer_links.url as direct_link"
    ).joins(
      "INNER JOIN online_retailer_links ON online_retailer_links.online_retailer_id = online_retailers.id"
    ).where(
      "online_retailer_links.brand_id = ?", website.brand_id
    ).sort_by{|o| o.preferred}
  end

  def self.random_without_preferred(website)
    where(active: true).where("preferred IS NULL or preferred < 1").select(
      "online_retailers.*, online_retailer_links.url as direct_link"
    ).joins(
      "INNER JOIN online_retailer_links ON online_retailer_links.online_retailer_id = online_retailers.id"
    ).where(
      "online_retailer_links.brand_id = ?", website.brand_id
    ).sort_by{rand}
  end

  # Retrieves the overall link where the OnlineRetailer lists the site's Brand products.
  def get_brand_link(website)
    begin
      @brand_link ||= online_retailer_link(website).url
    rescue
      return nil
    end
  end

  def online_retailer_link(website)
    @online_retailer_link ||= OnlineRetailerLink.where(online_retailer_id: self.id, brand_id: website.brand_id).first
  end

  def self.brand_online_retailers(website)
    where(active: true).where("online_retailer_links.position is not null").select(
      "online_retailers.*, online_retailer_links.url as direct_link"
    ).joins(
      "INNER JOIN online_retailer_links ON online_retailer_links.online_retailer_id = online_retailers.id"
    ).where(
      "online_retailer_links.brand_id = ?", website.brand_id
    ).order("online_retailer_links.position")
  end



  # Sets the overall link where this OnlineRetailer lists this site's Brand products.
  def set_brand_link(url, website)
    if website.brand_id > 0
      br = OnlineRetailerLink.where(online_retailer_id: self.id, brand_id: website.brand_id).first_or_initialize
      br.url = url
      br.save!
    else
      return false
    end
  end

  # Retrieves the brand sort order for the OnlineRetailer on the site's Where to Buy page.
  def get_retailer_sort_order(website)
    begin
      @brand_sort_order ||= online_retailer_link(website).position
    rescue
      return nil
    end
  end

  # Sets the sort order for OnlineRetailer on Where to Buy page.
  def set_retailer_sort_order(retailer_sort_order, website)
    if website.brand_id > 0
      br = OnlineRetailerLink.where(online_retailer_id: self.id, brand_id: website.brand_id).first_or_initialize
      br.position = retailer_sort_order
      br.save!
    else
      return false
    end
  end

end
