require "rails_helper"

RSpec.describe CustomShopMailer, type: :mailer do
	before :all do
    @quote = create(:custom_shop_quote_with_line_items)
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
  end
end
