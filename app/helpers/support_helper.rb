module SupportHelper

  def vintage_options
  	if website.vintage_products.size > 0
  		raw("<option disabled>--- Vintage Products ---</option>") +
		options_from_collection_for_select(website.vintage_products, :to_param, :name)
  	end
  end

end