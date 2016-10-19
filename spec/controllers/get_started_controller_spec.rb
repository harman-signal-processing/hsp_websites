require 'rails_helper'

RSpec.describe GetStartedController, type: :controller do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
    @get_started_page = FactoryGirl.create(:get_started_page, brand: @brand)
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET #index" do
    it "assigns @get_started_pages and returns http success" do
      get :index

      expect(assigns(:get_started_pages)).to include(@get_started_page)
      expect(response).to render_template('index')
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "assigns @get_started_page and returns http success" do
      get :show, id: @get_started_page.friendly_id

      expect(assigns(:get_started_page)).to eq(@get_started_page)
      expect(response).to render_template('show')
      expect(response).to have_http_status(:success)
    end
  end

end
