class CustomShopMailer < ApplicationMailer

  def request_quote(custom_shop_quote, options={})
    @custom_shop_quote = custom_shop_quote

    mail(to: @custom_shop_quote.recipients,
         subject: "Custom Shop Quote Request")
  end

  def send_quote_to_customer(custom_shop_quote)
    @custom_shop_quote = custom_shop_quote

    mail(to: @custom_shop_quote.user.email,
         subject: "Quote #{@custom_shop_quote.number} Updated")
  end
end
