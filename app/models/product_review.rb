class ProductReview < ActiveRecord::Base
  has_attached_file :review,
    url: ':s3_domain_url' # specified to avoid cloudfront usage
  do_not_validate_attachment_file_type :review

  has_attached_file :cover_image,
    styles: { lightbox: "800x600",
      large: "640x480", 
      medium: "480x360", 
      horiz_medium: "670x275",
      epedal: "400x250",
      vert_medium: "375x400",
      medium_small: "150x225",
      small: "240x180",
      horiz_thumb: "170x80",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    }
  validates_attachment :cover_image, content_type: { content_type: /\Aimage/i }

  validates :title, presence: true
  has_friendly_id :sanitized_title, use_slug: true, approximate_ascii: true, max_length: 100
  has_many :product_review_products, dependent: :destroy
  has_many :products, through: :product_review_products
  before_save :clear_blank_body, :reset_link_status, :stamp_link
  after_save :translate
  
  def sanitized_title
    self.title.gsub(/[\'\"]/, "")
  end
  
  def self.to_be_checked
    where(["link_checked_at <= ? OR link_checked_at IS NULL", 5.days.ago]).where("external_link IS NOT NULL AND external_link != ''").order("link_checked_at ASC")
  end
  
  def self.all_for_website(website)
    r = []
    all.each do |pr|
      r << pr if pr.products.select{|p| p if p.belongs_to_this_brand?(website)}.size > 0
    end
    r
  end
  
  def self.problems(website)
    r = []
    where("link_status != '200'").all.each do |pr|
      r << pr if pr.products.select{|p| p if p.belongs_to_this_brand?(website)}.size > 0
    end
    r
  end
  
  def stamp_link
    self.link_checked_at ||= Time.now
  end
  
  def clear_blank_body
    if self.body =~ /^<p><br _mce_bogus="1"><\/p>$/
      self.body = nil
    end
  end
  
  def reset_link_status
    self.link_status = '200' if self.external_link_changed?
  end

  # Alias for search results link_name
  def link_name
    self.title
  end
  
  # Alias for search results content_preview
  def content_preview
    self.body
  end
  
  # Used for link checking
  def url
    self.external_link
  end
  
  # For cross-functionality with News
  def post_on
    self.created_at.to_date
  end

  # Translates this record into other languages. 
  def translate
    if self.products && self.products.first
      ContentTranslation.auto_translate(self, self.products.first.brand)
    end
  end
  handle_asynchronously :translate
  
end
