class Toolkit::ToolkitResourcesController < ToolkitController
	layout "toolkit"
	load_resource :brand
	load_resource :toolkit_resource

	# After authorizing, send_file as indicated by the "download_path" attribute
	def show
		tk_folder = Rails.env.production? ? Rails.root.join("../", "../", "../", "toolkits") : Rails.root.join("../", "../", "toolkit")
		send_file(tk_folder + "/" + @toolkit_resource.download_path)
	end
end
