require "rails_helper"

RSpec.describe AdminController do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
    #@manager = FactoryGirl.create(:user, market_manager: true, confirmed_at: 1.minute.ago)
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET index for online retailer user" do
    it "redirects to the online retailers utility" do
      retailer = FactoryGirl.create(:online_retailer)
      retailer_user = FactoryGirl.create(:user, online_retailer: true, confirmed_at: 1.minute.ago)
      retailer.users << retailer_user
      sign_in(retailer_user, scope: :user)

      get :index

      expect(response).to redirect_to(admin_online_retailers_path)
    end
  end

  describe "GET index for a user with no access at all" do
    it "sets the @msg" do
      user = FactoryGirl.create(:user, confirmed_at: 1.minute.ago)
      sign_in(user, scope: :user)

      get :index

      expect(assigns(:msg)).to match("access to any resources")
      expect(response).to render_template(:index)
    end
  end
end
