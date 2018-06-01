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
              resource_type.titleize.pluralize
            end
          end
        end
      end
    end
  end

end
