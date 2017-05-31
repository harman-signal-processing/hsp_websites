class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates

  has_many :features, -> { order('position') }, as: :featurable, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :brand_id }
  validates :brand_id, presence: true
  validates :custom_route, uniqueness: true

  belongs_to :brand

  def slug_candidates
    [
      :sanitized_title,
      [:brand_name, :sanitized_title],
      [:brand_name, :sanitized_title, :custom_route]
    ]
  end

  def brand_name
    self.brand.name
  end

  def should_generate_new_friendly_id?
    true
  end

  def sanitized_title
    self.title.gsub(/[\'\"]/, "")
  end

  def self.all_for_website(website)
    where(brand_id: website.brand_id).all
  end

  # Alias for fancy features list
  def name
    title
  end

  # Alias for search results link_name
  def link_name
    self.title
  end

  # Alias for search results content_preview
  def content_preview
    self.body
  end

  # Checks if this page requires a username and password:
  def requires_login?
    !!!(self.username.blank? && self.password.blank?)
  end

  # Figure out if a field is protected to avoid config errors
  def disable_field?(attribute)
    value = eval("self.#{attribute.to_s}")
    if attribute == :custom_route
      return false if value.blank?
      !!(brand.settings.where("name LIKE '%url%' AND string_value LIKE '%#{value}%'").count > 0)
    end
  end

end
