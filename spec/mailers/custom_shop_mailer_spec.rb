require "rails_helper"

RSpec.describe CustomShopMailer, type: :mailer do
	before :all do
    @website = create(:website)
    @brand = @website.brand
    @product1 = create(:product, brand: @brand)
    @product2 = create(:product, brand: @brand)
    cart = create(:custom_shop_cart)
    create(:custom_shop_line_item, custom_shop_cart: cart, product: @product1, quantity: 2)
    create(:custom_shop_line_item, custom_shop_cart: cart, product: @product2, quantity: 10)
    @price_request = create(:custom_shop_price_request, custom_shop_cart: cart)
	end

	describe "request price" do
    before do
      allow_any_instance_of(Brand).to receive(:custom_shop_email).and_return('custom_shop@harman.com')
    end

    let(:mail) { CustomShopMailer.request_pricing(@price_request) }

    it "should go to the brand's custom shop email" do
      expect(mail.to).to include "custom_shop@harman.com"
    end

    it "should list the line items" do
      expect(mail.body).to have_text(@price_request.custom_shop_line_items.first.product.name)
    end

    it "should link to the price request" do
      expect(mail.body).to have_link(@price_request.number)
    end
  end
end
