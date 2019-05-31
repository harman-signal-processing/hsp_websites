class FaqsController < ApplicationController
	
	def index
		@faqs = Faq.joins(:product).where("brand_id = ?", @website.brand.id)
		@products = Product.joins(:faqs).where("brand_id = ?", @website.brand.id).uniq
		@faqs
	end
	
	def show 
	
	end

end  #  class FaqsController < ApplicationController
