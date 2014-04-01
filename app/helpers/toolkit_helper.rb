module ToolkitHelper

	# Figures out which brand should be in the Toolkit
	def toolkit_brands
		@toolkit_brands ||= Brand.where(name: ["BSS", "dbx", "IDX", "Lexicon", "DigiTech", "DOD"]).order("UPPER(name)").includes(:websites).select{|b| b if b.websites.size > 0}
	end

	# Adds css class to elements to bump the content over to show
	# the brand's twitter background (if there is one)
	#
	def bgoffset
		@bgoffset ||= "bg-offset" if @brand && @brand.default_website && File.exists?(Rails.root.join("app", "assets", "images", @brand.default_website.folder, "toolkit-background.jpg"))
	end

	# Collects ToolkitResource for a particular object. Outputs an array:
	#
	# toolkit_support_files(object [, options] )
	#  
	#   valid options:
	#      
	#     only:    searches the ToolkitResourceType for the matching "name"
	#              and only includes those types in the results.
	#
	#     exclude: searches the ToolkitResourceType for the matching "name"
	#              and excludes that type from the results.
	#
	def toolkit_support_files(object, options={})
		default_options = { only: nil, filter_out: nil }
		options = default_options.merge options

		toolkit_resource_types = ToolkitResourceType.where(related_model: object.class.to_s)

		if options[:only].present?
			toolkit_resource_types = toolkit_resource_types.where("name LIKE ?", "%#{options[:only]}%")
		end

		if options[:exclude].present?
			options[:exclude] = [options[:exclude]] if options[:exclude].is_a?(String)
			options[:exclude].each do |opt|
				toolkit_resource_types = toolkit_resource_types.where("name NOT LIKE ?", "%#{opt}%")	
			end
		end

		toolkit_resource_types.map do |trt|
			trt.toolkit_resources.where(related_id: object.id).accessible_by(current_ability, :read) 
		end.flatten
	end

	# A simple unordered list (ul) of the resources for the given object.
	# See #toolkit_support_files for valid options.
	#
	# list_toolkit_support_files_for(object, brand [, options])
	#
	def list_toolkit_support_files_for(object, brand, options={})
		items = toolkit_support_files(object, options)

		content_tag(:ul) do
			items.map do |item|
				content_tag(:li, link_to_toolkit_item(brand, item))
			end.join.html_safe
		end

	end

	# Like #list_toolkit_support_files_for, but this renders the links
	# as panels.
	#
	def panels_of_toolkit_support_files_for(object, brand, options={})
		default_options = { columns: "two" }
		options = default_options.merge options
		items = toolkit_support_files(object, options)

		if items.length > 0
			title = (options[:only].present?) ? options[:only].pluralize : "#{object.class.to_s.titleize} Resources"

			content_tag(:h5, "#{title}:", class: "subheader") +

			content_tag(:ul, class: "large-block-grid-6 small-block-grid-2") do 
				items.map do |item|
					content_tag(:li, link_to_toolkit_item(brand, item, panel: true)) 
				end.join.html_safe
			end
		end

	end

	# Separate rows for each ToolkitResourceType
	#
	def rows_of_panels_of_toolkit_support_files_for(object, brand, options={})
		ToolkitResourceType.all.map do |trt|
			options[:only] = trt.name
			panels_of_toolkit_support_files_for(object, brand, options)
		end.join.html_safe
	end

	# A link to a single ToolkitResource. By default, it will link
	# to the resource by its name. Provide an option[:image_size]
	# to link to the resource with an image.
	#
	# link_to_toolkit_item(brand, toolkit_resource [, options])
	#
	#   valid options:
	#      
	#   image_size: must correspond to the image sizes in the "tk_preview"
	#               paperclip attachment of the ToolkitResource, ignored
	#               when panel=true, instead the :tiny size is used.
	#
	#   hide_size:  the download size is hidden (not valid with panel=true)
	#
	#   panel:      when set to true, the link is rendered wrapped in a div
	#               with the class "panel"
	#
	def link_to_toolkit_item(brand, item, options={})
		size = (item.download_file_size.to_i > 0) ? " [#{number_to_human_size(item.download_file_size)}]" : ""
		path = toolkit_brand_toolkit_resource_path(brand, item)

		if options[:panel] == true
			link_to(path) do 
				content_tag(:div, class: "panel image-container", style: "text-align: center;") do 
					image_tag(item.tk_preview.url(:tiny)) +
					content_tag(:div, item.name, class: "fname") + size
				end
			end
		else
			size  = "" if options[:hide_size] == true
			label = (options[:image_size].present?) ? image_tag(item.tk_preview.url(options[:image_size]), alt: item.name) : item.name

			icon_for(item) + link_to(label, path) + size
		end
	end

	def icon_for(item)
		begin
			filename = item.download_path
			filename.match(/\.(.*)$/)
			file_extension = $1
			case file_extension.downcase
				when "pdf"
					image_tag("icons/pdf-icon.png") + ' '
				when "zip"
					image_tag("icons/zip-icon.png") + ' '
				when "exe"
					image_tag("icons/windows_17.png") + ' '
				when "dmg"
					image_tag("icons/mac_17.png") + ' '
				when "wav", "mp3", "aif"
					image_tag("icons/icon_play.png") + ' '
				when "m4v", "avi", "qt"
					image_tag("icons/icon_play.png") + ' '
				else
					''
			end
		rescue
			''
		end
	end

end
