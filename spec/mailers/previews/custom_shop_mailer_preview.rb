# Preview all emails at http://localhost:3000/rails/mailers/custom_shop_mailer
class CustomShopMailerPreview < ActionMailer::Preview

  def request_quote
    quote = build(:custom_shop_quote_with_line_items)
    CustomShopMailer.request_quote(quote)
  end
end
