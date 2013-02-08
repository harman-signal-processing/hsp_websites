class Toolkit::ToolkitResourcesController < ToolkitController
	layout "toolkit"
	load_resource :brand
	load_resource :toolkit_resource

	# After authorizing, send_file as indicated by the "download_path" attribute
	def show
		send_file(Rails.root.join("../", "../", "toolkit", @toolkit_resource.download_path))
	end
end
