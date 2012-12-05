module IstompHelper

	def burst_for(pedal)
		if included_epedals.include?(pedal.to_param)
			image_tag("#{website.folder}/istomp/included_burst.png", alt: "included")
		else
			image_tag("#{website.folder}/istomp/99cent_burst.png", alt: "99 cents")
		end
	end

	def included_epedals
		begin
			@included_epedals ||= website.included_epedals.split("|")
		rescue
			@included_epedals ||= ['redline-overdrive', 'total-recall']
		end
	end

end