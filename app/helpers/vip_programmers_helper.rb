module VipProgrammersHelper

	def get_filter_display_style
		if !cookies[:show_all_vip_filters].nil? 
	    @show_all_filters_display_style = "style=display:block;"
		else
	    @show_all_filters_display_style = "style=display:none;"
		end
	end

	def get_filter_text
		if !cookies[:show_all_vip_filters].nil? 
	    @more_filters_text = "Hide extra filters"
		else
	    @more_filters_text = "Show more filters"
		end
	end

end

