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
            if resource_type.to_s.match?(/software/i)
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
					    html += "<i class='fa fa-envelope' aria-hidden='true'></i>&nbsp;#{mail_to hash[keyname.to_sym]}<br />"
					  when "websites"
					    html += "<i class='fa fa-external-link' aria-hidden='true'></i>&nbsp;#{link_to hash[keyname.to_sym], hash[keyname.to_sym], target:"_blank"}<br />"
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

end  #  module SupportHelper
