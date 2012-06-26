class News < ActiveRecord::Base
  has_attached_file :news_photo, 
    :styles => { :large => "600>x370", 
      :medium => "350x350>", 
      :thumb => "100x100>", 
      :tiny => "64x64>", 
      :tiny_square => "64x64#" 
    }
  has_many :news_products, :dependent => :destroy
  has_many :products, :through => :news_products
  has_friendly_id :sanitized_title, :use_slug => true, :approximate_ascii => true, :max_length => 100
  validates_presence_of :brand_id, :title
  belongs_to :brand
  before_save :strip_harmans_from_title
  
  define_index do
    indexes :title
    indexes :body
    indexes :keywords
  end
  
  # When presenting the site to Rob before going live, he asked that we remove
  # the the word "HARMAN's" from the beginning of the news titles.
  def strip_harmans_from_title
    self.title.gsub!(/^HARMAN.s/, "")
    self.title.gsub!(/^\s*/, "")
  end
    
  def sanitized_title
    self.title.gsub(/[\'\"]/, "")
  end
  
  # News to display on the main area of the site. This set of news articles
  # includes entries from the past year.
  def self.all_for_website(website)
    where(:brand_id => website.brand_id).where(["post_on >= ? AND post_on <= ?", 1.year.ago, Date.today]).order("post_on DESC")
  end

  # Older news for the archived page. These are articles older than 1 year.
  def self.archived(website)
    where(:brand_id => website.brand_id).where(["post_on <= ?", 1.year.ago]).order("post_on DESC")
  end
  
  # Alias for search results link name
  def link_name
    self.title
  end
  
  # Alias for search results content preview
  def content_preview
    "#{I18n.l(self.created_at.to_date, :format => :long)} - #{self.body}"
  end
  
end
