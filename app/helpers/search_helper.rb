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
	
	def get_pdf_item_category(result)
		pdf_item = find_pdf_item_in_db(result)
		category = 'Uncategorized'
		if pdf_item.present?
			if pdf_item.respond_to? :resource_type
				category = pdf_item.resource_type
			elsif pdf_item.respond_to? :document_type
				category = pdf_item.document_type
			end
		end
		category
	end  #  def get_pdf_item_category(result)
	
	def get_pdf_item_title(result)
		pdf_item = find_pdf_item_in_db(result)
		if pdf_item.present?
			if pdf_item.language.present? && pdf_item.language != 'en'
				language = HarmanSignalProcessingWebsite::Application.config.document_languages.select{|l| l[1] == "#{pdf_item.language}"}[0][0]
				# add the language to the title if it is not present for non english documents
				title = (pdf_item.name.include? language) ? pdf_item.name : pdf_item.name + " (#{language})"
			else
				title = pdf_item.name
			end
		else
			title = strip_html(result[:ResultTitle])
		end
		# title = pdf_item.present? ? pdf_item.name : 
		title		
	end	
	
	def get_pdf_item_related_products(result)
		pdf_item = find_pdf_item_in_db(result)
		if pdf_item.present?
			if pdf_item.respond_to? :resource_type
				related_products = pdf_item.products
			elsif pdf_item.respond_to? :document_type
				related_products = pdf_item.product
			end
		end
		
		related_products
	end
	
	def find_pdf_item_in_db(result)
		filename = URI.decode(File.basename(result[:Url]).split('#')[0].gsub("_original.pdf",".pdf"))
		site_element = SiteElement.find_by(resource_file_name:"#{filename}")
		product_document = ProductDocument.find_by(document_file_name:"#{filename}")
		
		if site_element.present?
			pdf_item = site_element
		elsif product_document.present?
			pdf_item = product_document
		end
		pdf_item
	end
	
end  #  module SearchHelper
