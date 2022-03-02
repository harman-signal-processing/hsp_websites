class CustomShopMailer < ApplicationMailer

  def request_pricing(custom_shop_price_request, options={})
    @custom_shop_price_request = custom_shop_price_request

    mail(to: @custom_shop_price_request.recipients,
         subject: "Custom Shop Price Request")
  end

  def send_pricing_to_customer(custom_shop_price_request)
    @custom_shop_price_request = custom_shop_price_request

    mail(to: @custom_shop_price_request.user.email,
         subject: "Price Request #{@custom_shop_price_request.number} Updated")
  end
end
