class ProductDocument < ActiveRecord::Base
  belongs_to :product, touch: true
  has_attached_file :document #, url: ':s3_domain_url' # specified to avoid cloudfront usage
  process_in_background :document
  has_friendly_id :document_file_name, use_slug: true, approximate_ascii: true, max_length: 100
  validates_presence_of :product_id, :document

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
