class Testimonial < ApplicationRecord
  extend FriendlyId
  friendly_id :title

  belongs_to :brand
  has_many :product_family_testimonials, dependent: :destroy
  has_many :product_families, through: :product_family_testimonials

  has_attached_file :banner, {
    styles: { large: "640x480",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      title: "86x86",
      tiny: "64x64",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression] }.merge(S3_STORAGE)
  validates_attachment :banner, content_type: { content_type: /\Aimage/i }

  has_attached_file :image, {
    styles: { large: "640x480",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      title: "86x86",
      tiny: "64x64",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression] }.merge(S3_STORAGE)
  validates_attachment :image, content_type: { content_type: /\Aimage/i }

  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment

  process_in_background :attachment
  process_in_background :banner
  process_in_background :image

  validates :brand, :title, presence: true

  scope :not_associated_with_this_product_family, -> (product_family) {
    testimonial_ids_already_associated_with_this_product_family = ProductFamilyTestimonial.where(product_family: product_family).pluck(:testimonial_id)
    unscoped.where.not(id: testimonial_ids_already_associated_with_this_product_family)
  }

  def name
   title
  end
end
