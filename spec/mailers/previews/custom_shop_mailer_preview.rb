# Preview all emails at http://localhost:3000/rails/mailers/custom_shop_mailer
class CustomShopMailerPreview < ActionMailer::Preview

  # Rather than pollute the dev database, just pull the last
  # CustomShopPriceRequest (So, there must be one for this preview to work)
  def request_price
    custom_shop_price_request = CustomShopPriceRequest.last
    CustomShopMailer.request_price(custom_shop_price_request)
  end

end
