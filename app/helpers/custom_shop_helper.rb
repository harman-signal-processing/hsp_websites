module CustomShopHelper

  def current_custom_shop_cart
    begin
      @current_custom_shop_cart ||= CustomShopCart.find(session[:custom_shop_cart_id])
    rescue
      nil
    end
  end

  def custom_shop_quote_summary(custom_shop_quote)
    fields = []
    if custom_shop_quote.opportunity_number.present? || custom_shop_quote.opportunity_name.present?
      opportunity_fields = []
      opportunity_fields << custom_shop_quote.opportunity_number if custom_shop_quote.opportunity_number.present?
      opportunity_fields << custom_shop_quote.opportunity_name if custom_shop_quote.opportunity_name.present?
      fields << "Opportunity: #{opportunity_fields.join('/')}"
    end
    if custom_shop_quote.location.present?
      fields << custom_shop_quote.location
    end
    fields = [fields.join(", ")]
    fields << "[" + custom_shop_quote.custom_shop_line_items.map{|li| li.product.name}.uniq.join(", ") + "]"

    fields.join("<br/>").html_safe
  end
end
