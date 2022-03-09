class Innovation < ApplicationRecord
  extend FriendlyId
  friendly_id :sanitized_name
  
  belongs_to :brand
  has_many :product_innovations, dependent: :destroy
  has_many :products, through: :product_innovations
  
  acts_as_list scope: :brand
  
  has_attached_file :icon,
    styles: {
      large: "128x128",
      medium: "64x64",
      small: "32x32"
    }

  validates_attachment :icon, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  def slug_candidates
    [
      :sanitized_name,
      [:brand_name, :sanitized_name]
    ]
  end

  def brand_name
    self.brand.name
  end

  def should_generate_new_friendly_id?
    true
  end

  def sanitized_name
    self.name.gsub(/[\'\"]/, "")
  end

end
