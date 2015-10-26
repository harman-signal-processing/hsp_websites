require "rails_helper"

# Most of this controller's behavior is tested in the
# feature specs
RSpec.describe LabelSheetOrdersController do

  before :all do
    @website = FactoryGirl.create(:website_with_products)
    @istomp = FactoryGirl.create(:product, name: "iStomp", brand: @website.brand, cached_slug: "istomp")
    @stompshop = FactoryGirl.create(:software, name: "Stomp Shop", layout_class: "stomp_shop", brand: @website.brand)
    FactoryGirl.create(:product_software, product: @istomp, software: @stompshop)
  end

  before :each do
    @request.host = @website.url
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  describe "GET thanks without an order in the session" do
    it "redirects to the root" do
      get :thanks

      expect(response).to redirect_to(root_path)
    end
  end
end
