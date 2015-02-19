require 'rails_helper'

RSpec.describe SupportController, :type => :controller do

  before do
    @brand = FactoryGirl.create(:crown_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "crown", brand: @brand, url: "crown.lvh.me")
    @request.host = @website.url
  end

  describe "GET catalog_request" do
    before do
      get :catalog_request
    end

    it "initializes a contact_message" do
      expect(assigns(:contact_message)).to be_a_new(ContactMessage)
    end

    it "returns http success and renders template" do
      expect(response).to have_http_status(:success)
      expect(response).to render_template("catalog_request")
    end
  end

  describe "POST catalog_request" do

    before do
      post :catalog_request, contact_message: {
        name: "Joe Schmoe",
        email: "joe@schmoe.com",
        shipping_address: "123 Nowhere",
        shipping_city: "Somewhere",
        shipping_state: "IN",
        shipping_zip: "90210",
        shipping_country: "United States"
      }
    end

    it "sends catalog request" do
      expect(assigns(:contact_message).name).to eq("Joe Schmoe")
      expect(assigns(:contact_message).message_type).to eq("catalog_request")
      expect(assigns(:contact_message).valid?).to be(true)
    end

    it "returns to the support page, i guess" do
      expect(response).to redirect_to(support_path)
    end
  end

end
