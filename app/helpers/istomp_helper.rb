module IstompHelper

	def burst_for(pedal)
		if included_epedals.include?(pedal.to_param)
			image_tag("#{website.folder}/istomp/included_burst.png", alt: "included")
		elsif onsale_epedals.include?(pedal.to_param)
			image_tag("#{website.folder}/istomp/99cent_burst.png", alt: "99 cents")
		else
			""
		end
	end

	def included_epedals
		begin
			@included_epedals ||= website.included_epedals.split("|")
		rescue
			@included_epedals ||= ['redline-overdrive', 'total-recall']
		end
	end

	def onsale_epedals
		begin
			@onsale_pedals ||= website.featured_epedals.split("|") - featured_full_price_epedals
		rescue
			@onsale_pedals = []
		end
	end

	def featured_full_price_epedals
		begin
			f = [] 
			website.featured_epedals.split("|").each do |p|
				product = Product.find(p)
				f << p if product.sale_price.to_f >= product.msrp.to_f
			end
			f
		rescue 
			[]
		end
	end

end