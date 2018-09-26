module SearchHelper
	
	def get_result_image(item)
		begin
			case item.class.name
			when "Page"
				# image = image_url("#{website.folder}/logo.png")
			when "Product"
				image = item.photo.product_attachment.url(:thumb) if item.photo.present?
			when "ProductFamily"
				# image = image_url("#{website.folder}/logo.png")
			when "News"
				if item.news_photo.present?
					image = "#{item.news_photo.url(:thumb)}"
				end
			when "Artist"
				if item.artist_photo.present?
					image = "#{item.artist_photo.url(:thumb_square)}"
				end			
			else
				# image = image_url("#{website.folder}/logo.png")
			end  # case result.class.name
		rescue
			image = image_url("#{website.folder}/logo.png")
		end
		image
		
	end  #  def get_result_image(item)
	
	def results_item_count_range_for_page(results)
		if results.current_page == 1
			first_number = 1
			second_number = results.per_page
		else
			first_number = results.offset + 1
			if results.count == results.per_page
				second_number = first_number + results.per_page - 1
			else
				second_number = results.count + results.offset
			end
		end
		first_number.to_s + " - " + second_number.to_s
	end  #  def results_item_count_range_for_page(results)
	
	def current_item_number(results, count)
		if results.current_page == 1
			item_number = count
		else
			item_number = count + results.offset
		end
		
		item_number
	end  #  def current_item_number(results, count)
	
	def category_name(result_class_name)
		t("search_page.#{result_class_name.downcase}").titleize
	end
	
	def result_description(result)
		description = ""
		if result.class.name.downcase == "artist"
          if result.bio && !result.bio.blank? 
            description = truncate(strip_html(result.bio), length: 200) 
          end 			
		else
          if result.content_preview && !result.content_preview.blank? 
            description = truncate(strip_html(translate_content(result, result.content_preview_method)), length: 200) 
          end 
		end
		description
	end
	
end  #  module SearchHelper