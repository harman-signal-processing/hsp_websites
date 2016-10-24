require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
    @event = FactoryGirl.create(:event, brand: @brand, active: true)
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(assigns(:events)).to include(@event)
      expect(response).to render_temlate(:index)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, id: @event.to_param
      expect(assigns(:event)).to eq @event
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:success)
    end
  end

end
