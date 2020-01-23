class BrandSolutionFeaturedProduct < ApplicationRecord
  belongs_to :brand
  belongs_to :solution

  validates :brand, presence: true
  validates :solution, presence: true

  belongs_to :product, touch: true # (maybe--if not, the static fields should be required)
  validates :product, presence: true, if: :name_is_blank?

  validates :name, presence: true, if: :product_is_blank?
  validates :link, presence: true, if: :product_is_blank?
  #validates :description, presence: true, if: "product_id.nil?"

  has_attached_file :image, {
    styles: {
      full_width: "1024x768",
      lightbox: "800x600",
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
    }, processors: [:thumbnail, :compression] }.merge(S3_STORAGE)
  validates_attachment :image, content_type: { content_type: /\Aimage/i }

  acts_as_list scope: [:solution, :brand]

  attr_accessor :delete_image

  before_update :delete_image_if_needed

  def delete_image_if_needed
    unless self.image.dirty?
      if self.delete_image.present? && self.delete_image.to_s == "1"
        self.image = nil
      end
    end
  end

  def name_is_blank?
    name.nil?
  end

  def product_is_blank?
    product_id.nil?
  end

end
