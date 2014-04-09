class ProductDocument < ActiveRecord::Base
  belongs_to :product, touch: true
  has_attached_file :document
  process_in_background :document
  has_friendly_id :document_file_name, use_slug: true, approximate_ascii: true, max_length: 100

  validates :product_id, presence: true
  validates_attachment :document, presence: true
  do_not_validate_attachment_file_type :document

  # For cleaning up the product pages, no need to re-state the product name in
  # the link.
  #  
  def name(options={})
    if self.document_type.blank? || self.document_type.match(/other/i)
      self.document_file_name
    else
      doctype = I18n.t("document_type.#{self.document_type}")
      ret = (options[:hide_product_name]) ? doctype : "#{self.product.name} #{doctype}"
      unless self.language.blank? || !!(self.document_type.match(/^cad/))
        lang = I18n.t("language.#{self.language}")
        ret += "-#{lang}"
      end
      ret
    end
  end

end
