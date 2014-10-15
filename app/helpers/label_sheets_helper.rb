module LabelSheetsHelper

	def label_at(pos, label_sheet)
		if p = label_sheet.decoded_products[pos-1]
			if p.is_a?(Product)
				(p.images_for("product_page").size > 4) ? 
					image_tag(p.images_for("product_page")[4].product_attachment.url(:horiz_thumb), alt: p.name) :
					p.name
			else
				"unknown label"
			end
		else
			image_tag('digitech/istomp/Blank_iStompLabel_small.png', alt: "blank label")
		end
	end

end
