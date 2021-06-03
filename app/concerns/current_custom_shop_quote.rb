module CurrentCustomShopQuote

  private

  def set_custom_shop_quote
    if session[:custom_shop_quote_id].present?
      @custom_shop_quote = CustomShopQuote.find(session[:custom_shop_quote_id])
    elsif params[:uuid].present?
      @custom_shop_quote = CustomShopQuote.find(uuid: params[:uuid]).first_or_create
    else
      @custom_shop_quote = CustomShopQuote.create
    end

    session[:custom_shop_quote_id] = @custom_shop_quote.id
  end
end
