module SupportHelper

  def vintage_options
  	if website.vintage_products.size > 0
  		raw("<option disabled>--- Vintage Products ---</option>") +
		options_from_collection_for_select(website.vintage_products, :to_param, :name)
  	end
  end

  def downloads_header_row(resource_type, site_elements, options={})
    show_this_row = false
    site_elements.each do |site_element|
      next if show_this_row == true
      show_this_row = true if can?(:read, site_element)
    end
    if show_this_row == true
      content_tag(:tr) do
        content_tag(:td, colspan: options[:columns].to_i) do
          content_tag(:h6) do
            if (resource_type.to_s.match?(/software/i) || resource_type.to_s.match?(/firmware/i) || resource_type.to_s.match?(/declaration of conformity/i))
              resource_type.titleize
            else
              resource_type.titleize.pluralize.gsub(/3\s*D/i, "3D")
            end
          end
        end
      end
    end
  end
  
  def get_list_html(item, listname, keyname)
    listname_sym = listname.to_sym
    html = ""
			if item[listname_sym].present?
			 # key = listname.singularize
				  item[listname_sym].each do |hash|
				  	has_label = hash[:label].present?
					  case listname
					  when "emails"
					    html += email_html(has_label, hash, keyname)
					  when "websites"
					  	if hash[keyname.to_sym].present?
						  	#make sure the url contains the protocol
						  	url = hash[keyname.to_sym].match(/^http/).nil? ? "http://#{hash[keyname.to_sym]}" : hash[keyname.to_sym]
						    html += "<i class='fa fa-external-link' aria-hidden='true'></i>&nbsp;#{link_to hash[keyname.to_sym], url, target:"_blank"}<br />"
					  	end
					  when "phones"
							html += phone_html(has_label, hash, keyname)
					  else
					    html += "#{hash[keyname.to_sym]}<br />"
					  end
				end # item[listname_sym].each do |hash|
			end  # if item[symbol].present?
    html
  end  #  def get_list_html(item, listname, keyname)

  def address_html(item)
    html = ""
		html += "#{item[:address1]}<br />"
		if item[:address2].present?
			html += "#{item[:address2]}<br />"
		end
		if item[:address3].present?
			html += "#{item[:address3]}<br />"
		end
		html += "#{item[:city]} "
		if item[:state].present?
			html += " #{item[:state]} "
		end
		html += "#{item[:postal]}<br />"
		html += country_name(item[:country])
  end  #  def address_html(item)

	def phone_html(has_label, hash, keyname)
		html = ""
  	if has_label && hash[:label].downcase == "fax"
  		html += "<i class='fa fa-fax' aria-hidden='true'></i>&nbsp;" 
  	else
  		html += "<i class='fa fa-phone' aria-hidden='true'></i>&nbsp;"
  	end

	  html += "#{hash[:label]}: " if has_label
  	html += "#{hash[keyname.to_sym]}<br />"		
  	
  	html
	end  #  def phone_html(has_label, hash, keyname)

  def email_html(has_label, hash, keyname)
    html = ""
    html += "<i class='fa fa-envelope' aria-hidden='true'></i>&nbsp;"
    html += "#{hash[:label]}: " if has_label
    html += "#{mail_to hash[keyname.to_sym]}<br />"
    html
  end  #  def email_html(has_label, hash, keyname)

  def custom_sorted_service_centers
    if @service_centers.present?
      @service_centers.sort_by{|a|
        [
          # customer rating desc, make nils zeros
          -(a[:customer_rating].to_f||0),
          # name asc
          a[:name]
        ]
      }  #  @service_centers.sort_by{|a|
    else
      []
    end
  end  #  def custom_sorted_service_centers

  def customer_service_rating_css_class(rating)
    stars_html = case rating
      when 0.0
        "<i class='a-icon a-icon-star a-star-0'></i>"
      when 0.1..0.9
        "<i class='a-icon a-icon-star a-star-0-5'></i>"
      when 1.0
        "<i class='a-icon a-icon-star a-star-1'></i>"
      when 1.1..1.9
        "<i class='a-icon a-icon-star a-star-1-5'></i>"
      when 2.0
        "<i class='a-icon a-icon-star a-star-2'></i>"
      when 2.1..2.9
        "<i class='a-icon a-icon-star a-star-2-5'></i>"
      when 3.0
        "<i class='a-icon a-icon-star a-star-3'></i>"
      when 3.1..3.9
        "<i class='a-icon a-icon-star a-star-3-5'></i>"
      when 4.0
        "<i class='a-icon a-icon-star a-star-4'></i>"
      when 4.1..4.9
        "<i class='a-icon a-icon-star a-star-4-5'></i>"
      when 5.0
        "<i class='a-icon a-icon-star a-star-5'></i>"
    end  #  case rating
    stars_html
  end  #  def customer_service_rating_css_class(rating)

end  #  module SupportHelper
