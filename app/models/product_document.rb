class ProductDocument < ActiveRecord::Base
  belongs_to :product, touch: true
  has_attached_file :document,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  has_friendly_id :document_file_name, use_slug: true, approximate_ascii: true, max_length: 100
  validates_presence_of :product_id, :document
  
  # define_index do
  #   indexes :document_type
  #   indexes :document_file_name
  #   indexes product.name, as: :product_name
  #   has product_id
  # end
  
  def name
    if self.document_type.blank? || self.document_type.match(/other/i)
      self.document_file_name
    else
      doctype = I18n.t("document_type.#{self.document_type}")
      ret = "#{self.product.name} #{doctype}"
      unless self.language.blank?
        lang = I18n.t("language.#{self.language}")
        ret += "-#{lang}"
      end
      ret
    end
  end

  # # Alias for search results link_name
  # def link_name
  #   self.name
  # end
  # 
  # # Alias for search results content_preview
  # def content_preview
  #   nil
  # end
  
end
