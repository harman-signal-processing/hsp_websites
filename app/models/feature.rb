class Feature < ApplicationRecord
  belongs_to :featurable, polymorphic: true, touch: true

  validates :featurable_type, presence: true
  validates :featurable_id, presence: true
  validates :layout_style, presence: true

  acts_as_list scope: :featurable_id

  has_attached_file :image, {
    styles: {
      extra_large: "1100>x600",
      large: "600>x370",
      medium: "350x350>",
      thumb: "100x100>",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression] }.merge(SETTINGS_STORAGE)
  validates_attachment :image, content_type: { content_type: /\Aimage/i }

  attr_accessor :delete_image

  before_update :delete_image_if_needed

  def delete_image_if_needed
    unless self.image.dirty?
      if self.delete_image.present? && self.delete_image.to_s == "1"
        self.image = nil
      end
    end
  end

  def self.layout_options
    [
      ["Wide slide with text overlay", "wide"],
      ["Wide slide with text underneath", "wide2"],
      ["60/40 split", "split"],
      ["Review Quotes", "review_quotes"]
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

  def delete_image_if_necessary
    if !!(self.delete_image == 1) && !(self.image.dirty?)
      self.image = nil
    end
  end
end
