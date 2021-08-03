module CustomShopHelper

  def current_custom_shop_cart
    begin
      @current_custom_shop_cart ||= CustomShopCart.find(session[:custom_shop_cart_id])
    rescue
      nil
    end
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
end
