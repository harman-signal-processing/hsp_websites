class Toolkit::PromotionsController < ToolkitController
	before_filter :load_brand
	layout "toolkit"

	def index
	end

	def show
		@promotion = Promotion.find(params[:id])
	end
end
