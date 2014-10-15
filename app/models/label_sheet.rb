class LabelSheet < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  attr_accessor :product_ids
  serialize :products
  before_save :encode_product_ids

  def encode_product_ids
    if self.product_ids.present?
   		self.products = self.product_ids.split(/\,\s?/).map{|pi| Product.find(pi)}
    end
  end

  def decoded_products
    @decoded_products ||= self.needs_decoding? ? self.decode_products : self.products
  end

  def needs_decoding?
    !self.products.first.is_a?(Product)
  end

  def decode_products
    self.products.map{|p| Product.find(p["attributes"]["id"])}
  end

  def label_names
  	"#{self.decoded_products.map{|p| p.name}.join(", ")} #{blank_labels}"
  end

  def blank_labels
  	if self.products.count < 6
  		" + " + pluralize((6 - self.products.count), "blank label")
  	end
  end
end
