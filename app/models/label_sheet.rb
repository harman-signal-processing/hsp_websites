class LabelSheet < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  after_commit do
    self.decoded_products.each {|p| p.touch}
  end

  def decoded_products
    @decoded_products ||= self.product_ids.map{|p| Product.find(p)}
  end

  def label_names
  	@label_names ||= "#{self.decoded_products.map{|p| p.name}.join(", ")} #{blank_labels}"
  end

  def blank_labels
  	if self.product_ids.count < 6
      " + " + pluralize((6 - self.product_ids.length), "blank label")
  	end
  end

  def product_ids
    @product_ids ||= self.products.split(",")
  end

  def product_ids=(ids)
    self.products = ids
  end
end
