class Artist < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # TODO: some of these attributes will probably go away during the revamp
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :bio, 
    :artist_photo_file_name, :artist_photo_content_type, :artist_photo_updated_at, :artist_photo_file_size,
    :website, :twitter, :position, :cached_slug, :featured, :artist_photo,
    :artist_product_photo_file_name, :artist_product_photo_file_size, :artist_product_photo,
    :artist_product_photo_content_type, :artist_product_photo_updated_at,
    :invitation_code, :artist_tier_id, :main_instrument, :notable_career_moments,
    :artist_products_attributes, :initial_brand, :approver_id, :approved, :skip_unapproval
    
  attr_accessor :initial_brand, :approved, :skip_unapproval
  belongs_to :artist_tier
  has_many :artist_products, :dependent => :destroy, :inverse_of => :artist
  accepts_nested_attributes_for :artist_products, :reject_if => proc { |a| a[:product_id].blank? }, :allow_destroy => true
  before_create :set_artist_tier
  has_many :products, :through => :artist_products
  has_many :artist_brands, :dependent => :destroy
  has_many :brands, :through => :artist_brands
  belongs_to :approver, :class_name => "User", :foreign_key => "approver_id"
  before_save :clear_approval, :fix_website_format

  has_attached_file :artist_photo, 
    :styles => { :feature => "940x400#",
      :large => "400>x370", 
      :medium => "250x250#", 
      :thumb => "100x100>", 
      :thumb_square => "100x100#",
      :wide_thumb => "200x100#",
      :tiny => "64x64>", 
      :tiny_square => "64x64#" 
    }
  has_attached_file :artist_product_photo, 
    :styles => { :feature => "940x400#",
      :large => "400>x370", 
      :medium => "250x250#", 
      :thumb => "100x100>", 
      :thumb_square => "100x100#",
      :tiny => "64x64>", 
      :tiny_square => "64x64#" 
    }
  validates :name, :presence => true
  has_friendly_id :sanitized_name, :use_slug => true, :approximate_ascii => true, :max_length => 100
  acts_as_list

  define_index do
    indexes :name
    indexes :bio
  end
  
  def sanitized_name
    self.name.gsub(/[\'\"]/, "")
  end
  
  def belongs_to_this_brand?(website)
    begin
      self.brands.collect{|b| b.id}.include?(website.brand_id)
    rescue
      false
    end
  end
    
  def self.all_for_website(website)
    where("(approver_id IS NOT NULL AND approver_id != '') OR featured = 1").order("name").all.select{|a| a if a.belongs_to_this_brand?(website)}
  end
    
  # When a new artist signs up, build a few ArtistProduct slots
  def build_artist_products
    if self.new_record?
      self.artist_products.build(:favorite => true) if self.artist_products.size == 0
      until self.artist_products.size >= 4
        self.artist_products.build(:favorite => false)
      end
    end
  end
  
  # If the website doesn't have http:// in front, then add it.
  def fix_website_format
    if !self.website.blank? && !self.website.match(/^http/i)
      self.website = "http://#{self.website}"
    end
  end
  
  # When a new artist is created, assign them to an ArtistTier
  def set_artist_tier
    self.artist_tier_id ||= ArtistTier.default.id
    unless self.invitation_code.blank?
      self.artist_tier = ArtistTier.find_by_invitation_code(self.invitation_code)
    end
  end
  
  # Clear the approval field if the artist changed their photos
  def clear_approval
    unless self.skip_unapproval == true
      if self.artist_photo_file_size_changed? || self.artist_product_photo_file_size_changed? ||
        self.bio_changed? || self.website_changed? || self.name_changed? && !self.approver_id_was.blank?
          logger.info " ============--------> Unapproving artist: #{self.name}"
          self.approver_id = nil
          artist_relations = User.artist_relations
          aritst_relations = User.all unless (Rails.env.production? || Rails.env.staging?)
          if artist_relations.size > 0
            SiteMailer.delay.artist_approval(self, artist_relations.collect{|user| user.email})
          end
      end
    end
  end
  
  # Retrieve any quote for the provided product
  def quote_for(product)
    begin
      self.artist_products.where(product_id: product.id).first.quote
    rescue
      ""
    end
  end
  
  # Alias for search results link_name
  def link_name
    self.name
  end
  
  # Alias for search results content_preview
  def content_preview
    self.name
  end

  def has_summary?
    # self.summary.to_s.size > 28
    false
  end
  
  # Determine the approval status of this Artist
  def approval_status
    (self.approver_id.blank?) ? "Pending" : "Approved by #{self.approver.name}"
  end
end
