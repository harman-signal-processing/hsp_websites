module ToolkitHelper

	def toolkit_brands
		@toolkit_brands ||= Brand.where(name: ["BSS", "dbx", "Lexicon", "DigiTech", "DOD"]).select{|b| b if b.websites.size > 0}
	end

	def toolkit_support_files(object, type_filter=nil)
		toolkit_resource_types = ToolkitResourceType.where(related_model: object.class.to_s)

		if type_filter.present?
			toolkit_resource_types = toolkit_resource_types.where("name LIKE ?", type_filter)
		end

		toolkit_resource_types.map do |trt|
			trt.toolkit_resources.where(related_id: object.id)
		end.flatten
	end

end
