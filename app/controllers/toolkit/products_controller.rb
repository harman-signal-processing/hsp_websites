class Toolkit::ProductsController < ToolkitController
	before_filter :load_brand
	layout "toolkit"

	def index
	end

	def show
		@product = Product.find(params[:id])
	end
end
