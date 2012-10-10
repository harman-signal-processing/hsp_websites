class Toolkit::BrandsController < ToolkitController
	layout "toolkit"

	def show
		@brand = Brand.find(params[:id])
	end
end
