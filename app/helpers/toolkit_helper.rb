module ToolkitHelper

	def toolkit_brands
		@toolkit_brands ||= Brand.where(name: ["BSS", "dbx", "Lexicon", "DigiTech", "DOD"]).select{|b| b if b.websites.size > 0}
	end
end
