class Toolkit::ProductsController < ToolkitController
	layout "toolkit"
	load_resource :brand
	load_resource :product, except: :index

	def index
	end

	def show
		if image_type = ToolkitResourceType.where(related_model: "Product").where("name LIKE '%photo%'").first
			@images = ToolkitResource.where(toolkit_resource_type_id: image_type.id, related_id: @product)
		end
		unless @images.length >= 12
			@images += @product.images_for("toolkit").select{|pa| pa if pa.is_photo?}
		end
	end

end
