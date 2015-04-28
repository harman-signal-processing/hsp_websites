class Toolkit::ProductsController < ToolkitController
	layout "toolkit"
	load_resource :brand
	load_resource :product, except: :index

	def index
	end

	def show
		@images = []
		if image_type = ToolkitResourceType.where(related_model: "Product").where("name LIKE '%photo%'").first
			@images = ToolkitResource.where(toolkit_resource_type_id: image_type.id, related_id: @product).accessible_by(current_ability, :read)
		end
		@images += @product.images_for("toolkit").select{|pa| pa if pa.is_photo?}
	end

end
