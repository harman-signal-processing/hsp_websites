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
	
	def has_training(programmer, training_name)
		if programmer.trainings.map{|training| training.name == training_name}.any?
			"."
		end
	end	
	
	def for_market(programmer, market_name)
		if programmer.markets.map{|market| market.name == market_name}.any?
			"."
		end		
	end
	
	def is_amx_solutions_master?(programmer)
		programmer.trainings.map{|item| item.name == "AMX Solutions Master (ASM)"}.any?
	end
	
	def show_items_table(items, column_count)
		@list = items
		@slice_count = column_count
		render "item_table"
	end
	
	def show_trainings(trainings, category, column_count)
		@list = get_trainings_based_on_category(trainings, category)
		list_count = @list.nil? ? 0 : @list.count
		@slice_count = column_count
		
		render partial: "item_table_trainings", locals: {heading: category } if list_count > 0
	end
	
	def get_trainings_based_on_category(trainings, category)
		case category
			when 'Audio'
				list = audio_trainings(trainings)
			when 'Control'
				list = control_trainings(trainings)
			when 'Networked AV'
				list = networked_av_trainings(trainings)
			else
				list = other_trainings((trainings))
		end  #  case category
		list
	end
	
	def clean_training_name(training_name)
		training_name.include?(" | ") ? training_name.split(" | ")[1] : training_name
	end
	
	def audio_trainings(trainings)
		trainings.select{|item| item.name.starts_with?("Audio ") }
	end
	
	def control_trainings(trainings)
		trainings.select{|item| item.name.starts_with?("Control ") }
	end
	
	def networked_av_trainings(trainings)
		trainings.select{|item| item.name.starts_with?("Networked AV ") }
	end
	
	def other_trainings(trainings)
		trainings.reject{|item| item.name.starts_with?("Audio ") || item.name.starts_with?("Control ") || item.name.starts_with?("Networked AV ") }
	end

end

