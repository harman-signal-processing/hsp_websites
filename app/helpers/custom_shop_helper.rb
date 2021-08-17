module CustomShopHelper

  def current_custom_shop_cart
    begin
      @current_custom_shop_cart ||= CustomShopCart.find(session[:custom_shop_cart_id])
    rescue
      nil
    end
  end

  def custom_shop_items_for(product_family)
    items = []
    skippable = []
    subfamily_products = {}

    product_family.children.where(group_on_custom_shop: true).each do |subfamily|
      subfamily_products[subfamily] = subfamily.current_products_plus_child_products(website)

      if subfamily_products[subfamily].length > 0
        items << subfamily
        skippable += subfamily_products[subfamily].map{|p| p.id}
      end
    end

    product_family.current_products_plus_child_products(website).each do |product|
      unless skippable.include?(product.id)
        items << product
      end
    end

    items.uniq.sort_by(&:name).map do |item|
      if item.is_a?(ProductFamily)
        render "custom_shop/product_family_square", subfamily: item, subfamily_products: subfamily_products[item]
      else
        render "custom_shop/product_square", product: item
      end
    end.join.html_safe
  end

  def custom_shop_price_request_summary(custom_shop_price_request)
    fields = []
    if custom_shop_price_request.opportunity_number.present? || custom_shop_price_request.opportunity_name.present?
      opportunity_fields = []
      opportunity_fields << custom_shop_price_request.opportunity_number if custom_shop_price_request.opportunity_number.present?
      opportunity_fields << custom_shop_price_request.opportunity_name if custom_shop_price_request.opportunity_name.present?
      fields << "Opportunity: #{opportunity_fields.join('/')}"
    end
    if custom_shop_price_request.location.present?
      fields << custom_shop_price_request.location
    end
    fields = [fields.join(", ")]
    fields << "[" + custom_shop_price_request.custom_shop_line_items.map{|li| li.product.name}.uniq.join(", ") + "]"

    fields.join("<br/>").html_safe
  end

  def custom_shop_custom_value_label(form_element)
   form_element.object.customizable_attribute.name.to_s.match?(/color/i) ? ral_color_label : "Custom value"
  end

  def ral_color_label
   "RAL Color Code #{ ral_reference_link }".html_safe
  end

  def ral_reference_link
    link_to("https://ralcolor.com", target: "_blank") do
      fa_icon "external-link"
    end
  end

end
