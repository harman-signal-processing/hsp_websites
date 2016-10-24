class Event < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  belongs_to :brand

  has_attached_file :image, {
    styles: { large: "1200x600",
      medium: "600x300",
      small: "300x150",
      thumb: "150x75",
      tiny: "75x32",
      tiny_square: "32x32#"
    }}.merge(S3_STORAGE)
  validates_attachment :image, content_type: { content_type: /\Aimage/i }

  # Events to display on the main area of the site.
  def self.all_for_website(website, options={})
    brand = website.is_a?(Website) ? website.brand : website

    brand.events
  end

end
