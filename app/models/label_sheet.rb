class LabelSheet < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  attr_accessible :name, :products, :product_ids
  attr_accessor :product_ids
  serialize :products
  before_save :encode_product_ids

  def encode_product_ids
    if self.product_ids.present?
   		self.products = self.product_ids.split(/\,\s?/).map{|pi| Product.find(pi)}
    end
  end

  def label_names
  	"#{self.products.map{|p| p.name}.join(", ")} #{blank_labels}"
  end

  def blank_labels
  	if self.products.count < 6
  		" + " + pluralize((6 - self.products.count), "blank label")
  	end
  end
end
