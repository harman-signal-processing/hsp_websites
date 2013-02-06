class Toolkit::ToolkitResourcesController < ToolkitController
	load_and_authorize_resource :toolkit_resource

	# After authorizing, send_file as indicated by the "download_path" attribute
	def show
		send_file(Rails.root.join("../", "../", "shared", "storage", @toolkit_resource.download_path))
	end
end
