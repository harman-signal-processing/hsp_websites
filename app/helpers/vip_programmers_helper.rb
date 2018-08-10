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

	def provides_service(programmer, service_name)
		if programmer.services.map{|service| service.name == service_name}.any?
			"."
		end
	end
	
	def for_market(programmer, market_name)
		if programmer.markets.map{|market| market.name == market_name}.any?
			"."
		end		
	end
	
	def is_amx_solutions_master?(programmer)
		programmer.certifications.map{|cert| cert.name == "AMX Solutions Master"}.any?
	end

end

