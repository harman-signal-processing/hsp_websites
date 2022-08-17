class Artist < ApplicationRecord
  extend FriendlyId
  friendly_id :sanitized_name

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :async,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :initial_brand, :approved, :skip_unapproval
  belongs_to :artist_tier
  has_many :artist_products, dependent: :destroy, inverse_of: :artist
  accepts_nested_attributes_for :artist_products, reject_if: proc { |a| a[:product_id].blank? }, allow_destroy: true
  before_validation :set_artist_tier, on: :create
  has_many :products, through: :artist_products
  has_many :artist_brands, dependent: :destroy
  has_many :brands, through: :artist_brands
  belongs_to :approver, class_name: "User", foreign_key: "approver_id", optional: true
  before_save :clear_approval, :fix_website_format

  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"

  has_attached_file :artist_photo, {
    styles: { feature: "940x400#",
      large: "400>x370",
      medium: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      wide_thumb: "200x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression] }
  validates_attachment :artist_photo, content_type: { content_type: /\Aimage/i }

  has_attached_file :artist_product_photo, {
    styles: { feature: "940x400#",
      large: "400>x370",
      medium: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression] }
  validates_attachment :artist_product_photo, content_type: { content_type: /\Aimage/i }

  validates :name, presence: true

  acts_as_list

  # Sometimes in the mailer, brand isn't determined yet. Run through some
  # fallbacks to make sure we have one when needed...
  def brand_for_mailer
    if self.brands && self.brands.length > 0
      self.brands.first
    elsif self.initial_brand.present?
      self.initial_brand
    elsif Brand.count > 0
      Brand.first
    else
      Brand.new
    end
  end

  # Since the devise mailer is shard with other users, trick these
  def needs_invitation_code?
    false
  end

  def needs_account_number?
    false
  end

  def sanitized_name
    self.name.gsub(/[\'\"]/, "")
  end

  def belongs_to_this_brand?(website)
    !!(self.artist_brands.where(brand_id: website.brand_id).size > 0)
  end

  def self.all_for_website(website, order="name")
    where("(approver_id IS NOT NULL AND approver_id != '') OR featured = 1").
      joins(:artist_brands).
      where("artist_brands.brand_id = ?", website.brand_id).
      order("artists.#{order}")
  end

  # When a new artist signs up, build a few ArtistProduct slots
  def build_artist_products
    if self.new_record?
      self.artist_products.build(favorite: true) if self.artist_products.size == 0
      until self.artist_products.size >= 4
        self.artist_products.build(favorite: false)
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
    if self.invitation_code.present?
      self.artist_tier = ArtistTier.where(invitation_code: self.invitation_code).first
    end
  end

  def show_banner?
    !(self.artist_tier == ArtistTier.default)
  end

  # Clear the approval field if the artist changed their photos
  def clear_approval
    unless self.skip_unapproval == true
      if self.artist_photo_file_size_changed? || self.artist_product_photo_file_size_changed? ||
        self.bio_changed? || self.website_changed? || self.name_changed? && !self.approver_id_was.blank?
          logger.info " ============--------> Unapproving artist: #{self.name}"
          self.approver_id = nil
          artist_relations = User.artist_relations
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
    self.send(link_name_method)
  end

  def link_name_method
    :name
  end

  # Alias for search results content_preview
  def content_preview
    self.send(content_preview_method)
  end

  def content_preview_method
    :name
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
