require "rails_helper"

RSpec.describe ProductsController do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET :index (/products)" do
    it "redirects to the product_families page" do
      get :index

      expect(response).to redirect_to(product_families_path)
    end
  end
end


