class TrainingCourse < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates

  has_attached_file :image,
    styles: {
      large: "1200>x400",
      medium: "600>x600",
      small: "350x350>",
      thumb: "100x100>",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }
  validates_attachment :image, content_type: { content_type: /\Aimage/i }

  has_many :training_classes
  belongs_to :brand
  validates :brand_id, :name, presence: true

  def slug_candidates
    [
      :name,
      [:brand_name, :name],
      [:brand_name, :name, :short_description]
    ]
  end

  def brand_name
    brand.name
  end

  def upcoming_classes
    training_classes.where("start_at >= ?", Date.today).order("start_at ASC")
  end
end
