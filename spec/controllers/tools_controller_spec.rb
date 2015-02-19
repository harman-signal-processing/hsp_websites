require 'rails_helper'

RSpec.describe ToolsController, :type => :controller do

  before do
    @brand = FactoryGirl.create(:crown_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "crown", brand: @brand, url: "crown.lvh.me")
    @request.host = @website.url
  end

  describe "GET calculators" do
    it "returns http success" do
      get :calculators
      expect(response).to have_http_status(:success)
    end

    it "renders tools/calculators" do
      get :calculators
      expect(response).to render_template("calculators")
    end
  end

end
