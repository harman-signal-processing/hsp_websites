class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates

  has_many :features, -> { order('position') }, as: :featurable, dependent: :destroy

  has_many :content_translations, as: :content

  validates :title, presence: true, uniqueness: { scope: :brand_id, case_sensitive: false }
  validates :brand_id, presence: true
  validates :custom_route, uniqueness: { case_sensitive: false, allow_blank: true }

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
    self.send(link_name_method)
  end

  def link_name_method
    :title
  end

  # Alias for search results content_preview
  def content_preview
    self.send(content_preview_method)
  end

  def content_preview_method
    :body
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
      !!(brand.settings.where("name LIKE '%url%' AND string_value LIKE '%#{value}%'").size > 0)
    end
  end

end
