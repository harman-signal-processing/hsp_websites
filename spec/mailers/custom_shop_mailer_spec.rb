require "rails_helper"

RSpec.describe CustomShopMailer, type: :mailer do
	before :all do
    @cart = create(:custom_shop_cart_with_line_items)
    @quote = create(:custom_shop_quote, custom_shop_cart: @cart)
    @brand = @quote.brand
	end

	describe "request quote" do
    before do
      allow_any_instance_of(Brand).to receive(:custom_shop_email).and_return('custom_shop@harman.com')
    end

    let(:mail) { CustomShopMailer.request_quote(@quote) }

    it "should go to the brand's custom shop email" do
      expect(mail.to).to include "custom_shop@harman.com"
    end

    it "should list the line items" do
      expect(mail.body).to have_text(@cart.custom_shop_line_items.first.product.name)
    end
  end
end
