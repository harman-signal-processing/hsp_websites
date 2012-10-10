module ToolkitHelper

	def toolkit_brands
		@toolkit_brands ||= Brand.order("name").all.select{|b| b if b.websites.size > 0}
	end
end
