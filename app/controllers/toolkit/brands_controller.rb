class Toolkit::BrandsController < ToolkitController
	layout "toolkit"
	load_resource :brand

	def show
    if @marketing_message_type = ToolkitResourceType.where(marketing_message: true).first
    	@marketing_messages = ToolkitResource.where(brand_id: @brand.id, toolkit_resource_type_id: @marketing_message_type.id).where("expires_on > ? OR expires_on IS NULL", Date.today).accessible_by(current_ability, :read)
    else
    	@marketing_messages = []
    end
	end

end
