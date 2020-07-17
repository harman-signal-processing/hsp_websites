class ProductDocument < ApplicationRecord
  extend FriendlyId
  friendly_id :document_file_name

  belongs_to :product, touch: true
  has_attached_file :document

  acts_as_list scope: :product_id

  validates :product_id, presence: true
  validates_attachment :document, presence: true
  do_not_validate_attachment_file_type :document

  process_in_background :document

  # For cleaning up the product pages, no need to re-state the product name in
  # the link.
  def name(options={})
    if self.name_override.present?
      self.name_override
    elsif self.document_type.blank? || self.document_type.match(/other/i)
      self.document_file_name
    else
      doctype = I18n.t("document_type.#{self.document_type}")
      ret = (options[:hide_product_name]) ? doctype : "#{self.product.name} #{doctype}"
      unless self.language.blank? || !!(self.document_type.match(/^cad/)) || (options[:hide_language])
        lang = I18n.t("language.#{self.language}")
        ret += "-#{lang}"
      end
      ret
    end
  end

  def url
    "/#{I18n.locale.to_s}/product_documents/#{self.to_param}"
  end

  # Gathers up all the ProductDocument downloads for a given website. Returns a hash
  # that is used by the support downloads page.
  def self.downloads(website)
    Rails.cache.fetch("#{website.cache_key_with_version}/#{I18n.locale}/product_downloads", expires_in: 1.day) do
      downloads = {}
      where(product_id: website.current_and_discontinued_product_ids).find_each do |product_document|
        if product_document.for_current_locale?
          downloads = downloads.deep_merge({ product_document.hash_key => product_document.details_hash })
        end
      end
      downloads
    end
  end

  # Returns the individual hash data for a given ProductDocument. Highly cached as it
  # isn't likely to change often.
  def details_hash
    Rails.cache.fetch("#{cache_key_with_version}/#{I18n.locale}/details_hash", expires_in: 2.weeks) do
      {
        param_name: hash_key,
        name: doctype_name,
        downloads: [download_details_hash]
      }
    end
  end

  # Used by the ProductDocument#downloads method to see if the current ProductDocument
  # is relevant to the session's locale
  def for_current_locale?
    I18n.locale.to_s.match(/^en/i) || language.to_s.match(/^en/i) || I18n.locale.to_s.match(/#{language.to_s}/i)
  end

  # Determines the key to be used in the hash collection of all the downloads
  def hash_key
    key = document_type.blank? ? "other" : document_type.singularize.downcase.gsub(/[^a-z]/, '')
    key = I18n.t("language.#{language}", locale: 'en') + "-#{key}" if prepend_language_to_names?
    key += "-discontinued" if key == "cutsheet" && product.discontinued?
    key.parameterize
  end

protected

  # Determines the name of the document type to be used in the hash of all the downloads
  def doctype_name
    doctype = document_type.blank? ? "Other Document" : I18n.t("document_type.#{document_type}")
    doctype = "#{I18n.t("language.#{language}")} #{doctype}" if prepend_language_to_names?
    doctype_name = I18n.locale.match(/zh/i) ? doctype : doctype.pluralize
    if hash_key.match?(/cutsheet/)
      doctype_name += product.discontinued? ? " (Discontinued)" : " (Current)"
    end
    doctype_name
  end

  # Just a simple hash of attributes to be used in the big hash of all the downloads
  def download_details_hash
    {
      name: name.to_s.match?(/#{product.name}/) ? name : "#{product.name} #{name}",
      file_name: document_file_name,
      url: url,
    }
  end

  # Determines if the hash_key and doctype_name should incorporate the language of the
  # document.
  def prepend_language_to_names?
    !(language.blank? || document_type.to_s.match?(/^cad/i))
  end
end
