class Toolkit::PromotionsController < ToolkitController
	before_filter :load_brand
	layout "toolkit"

	def index
		@promotions = Promotion.all_for_website(@brand.default_website)
	end

	def show
		@promotion = Promotion.find(params[:id])
	end
end
