require 'rails_helper'

RSpec.describe ToolsController, :type => :controller do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
  end

  before :each do
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
