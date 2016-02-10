require "rails_helper"

RSpec.describe UsRepsController do

  before :all do
    @website = FactoryGirl.create(:website)
    @rep_region = FactoryGirl.create(:us_rep_region, brand: @website.brand)
    @rep = @rep_region.us_rep
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET show" do
    it "shows the rep details" do
      get :show, id: @rep.id

      expect(assigns(:us_rep)).to eq(@rep)
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:success)
    end
  end
end
