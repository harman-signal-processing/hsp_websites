class Feature < ApplicationRecord
  belongs_to :featurable, polymorphic: true, touch: true

  attr_accessor :display_option
  validates :featurable_type, presence: true
  validates :featurable_id, presence: true
  validates :layout_style, presence: true

  acts_as_list scope: :featurable_id

  has_attached_file :image, {
    styles: {
      extra_large: ["1100>x600", :webp],
      large: ["600>x370", :webp],
      medium: "350x350>",
      thumb: "100x100>",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression],
    convert_options: {
      extra_large: "-define webp:lossless=true "
    }}.merge(SETTINGS_STORAGE)
  validates_attachment :image, content_type: { content_type: /\Aimage/i }

  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"
  attr_accessor :delete_image

  has_attached_file :video
  validates_attachment :video, content_type: { content_type: /\Avideo/i }
  attr_accessor :delete_video

  before_update :delete_image_if_needed, :delete_video_if_needed

  def delete_image_if_needed
    unless self.image.dirty?
      if self.delete_image.present? && self.delete_image.to_s == "1"
        self.image = nil
      end
    end
  end

  def delete_video_if_needed
    unless self.video.dirty?
      if self.delete_video.present? && self.delete_video.to_s == "1"
        self.video = nil
      end
    end
  end

  def self.layout_options
    [
      ["Wide slide with text overlay", "wide"],
      ["Wide slide with text underneath", "wide2"],
      ["60/40 split", "split"],
      ["50/50 split", "5050_split"],
      ["Review Quotes", "review_quotes"]
    ]
  end

  def self.special_display_options
    [
      ["Default", "default"],
      ["Use as banner slide", "slide"],
      ["Show under products section", "under_products"],
      ["Show under videos section", "under_videos"]
    ]
  end

  def self.featurable_options
    [["Product Family", "ProductFamily"], ["Landing Page", "Page"]]
  end

  def name
    if featurable.present?
      "#{featurable.name} #{layout_style} feature #{position}"
    else
      "Missing #{featurable_type} (ID: #{featurable_id}) #{layout_style} feature #{position}"
    end
  end

  def feature_to_mark_checked
    answer = "nothing"
    if use_as_banner_slide == false && show_below_products == false && show_below_videos == false
      answer = "default"
    end
    answer = "slide" if use_as_banner_slide == true
    answer = "under_products" if show_below_products == true
    answer = "under_videos" if show_below_videos == true
    display_option = answer
  end  #  def feature_to_mark_checked

  def delete_image_if_necessary
    if !!(self.delete_image == 1) && !(self.image.dirty?)
      self.image = nil
    end
  end
end
