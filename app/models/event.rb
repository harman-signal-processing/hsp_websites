class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates

  belongs_to :brand

  has_attached_file :image, {
    styles: { large: "1200x600",
      medium: "600x300",
      small: "300x150",
      thumb: "150x75",
      tiny: "75x32",
      tiny_square: "32x32#"
    }, processors: [:thumbnail, :compression] }.merge(S3_STORAGE)
  validates_attachment :image, content_type: { content_type: /\Aimage/i }
  validates :start_on, presence: true
  validates :end_on, presence: true
  validates :brand, presence: true

  scope :current_and_upcoming, -> {
    unscoped.where(active: true).where("end_on >= ?", Date.today).order(start_on: :asc)
  }

  scope :recent, -> {
    unscoped.where(active: true).where("end_on <= ? AND end_on >= ?", Date.today, 6.months.ago).order(start_on: :desc)
  }

  # Events to display on the main area of the site.
  scope :all_for_website, -> (website, options={}) {
    brand = website.is_a?(Website) ? website.brand : website
    brand.events
  }

  def slug_candidates
    [
      :name,
      [:start_on, :name]
    ]
  end

  def should_generate_new_friendly_id?
    true
  end

end
