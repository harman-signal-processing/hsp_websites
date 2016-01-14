require 'rails_helper'

RSpec.describe NewsController, :type => :controller do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
    @future_news = FactoryGirl.create(:news, brand: @website.brand, post_on: 1.month.from_now, title: "Future News")
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET index" do
    before do
      get :index
    end

    it "future news should not appear on the index" do
      expect(assigns(:news)).not_to include(@future_news)
    end
  end

  describe "GET show" do

    it "future news should redirect to the index" do
      get :show, id: @future_news.id

      expect(response).to redirect_to(news_index_path)
    end

  end

end

