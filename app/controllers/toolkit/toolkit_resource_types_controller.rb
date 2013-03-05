class Toolkit::ToolkitResourceTypesController < ToolkitController
	layout "toolkit"
	load_resource :brand
	load_resource :toolkit_resource_type

	def show
		@toolkit_resources = @toolkit_resource_type.brand_resources(@brand).accessible_by(current_ability, :read) 
	end
	
end
