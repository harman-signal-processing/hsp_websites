# Preview all emails at http://localhost:3000/rails/mailers/custom_shop_mailer
class CustomShopMailerPreview < ActionMailer::Preview

  # Rather than pollute the dev database, just pull the last
  # CustomShopQuote (So, there must be one for this preview to work)
  def request_quote
    custom_shop_quote = CustomShopQuote.last
    CustomShopMailer.request_quote(custom_shop_quote)
  end

end
