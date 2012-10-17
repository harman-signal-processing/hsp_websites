class LabelSheet < ActiveRecord::Base
  attr_accessible :name, :products, :product_ids
  attr_accessor :product_ids
  serialize :products
  before_save :decode_product_ids

  def decode_product_ids
  	self.products = []
  	self.product_ids.split(/\,\s?/).each do |pi|
  		self.products << Product.find(pi)
  	end
  end

  def label_names
  	self.products.map{|p| p.name}.join(", ") + blank_labels
  end

  def blank_labels
  	if self.products.count < 6
  		" + #{6 - self.products.count} blank label(s)"
  	end
  end
end
