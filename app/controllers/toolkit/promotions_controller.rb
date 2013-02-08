class Toolkit::PromotionsController < ToolkitController
	layout "toolkit"
	load_resource :brand
	load_resource :promotion, except: :index

	def index
		@promotions = Promotion.all_for_website(@brand.default_website)
	end

	def show
	end

end
