require "rails_helper"

RSpec.describe Admin::NewsController do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
    @news = FactoryGirl.create(:news, brand: @brand)
    @user = FactoryGirl.create(:user, market_manager: true, confirmed_at: 1.minute.ago)
  end

  before :each do
    @request.host = @website.url
    sign_in(:user, @user)
  end

  describe "PUT :update" do
    before do
      post :update, id: @news.id, news: { title: "Harman restructures again." }
      @news.reload
    end

    it "Updates the news" do
      expect(@news.title).to eq "Harman restructures again."
    end

    it "redirects to the news article" do
      expect(response).to redirect_to admin_news_path(@news)
    end
  end

  describe "PUT :update unsuccessfully" do
    before do
      post :update, id: @news.id, news: { title: "" }
      @news.reload
    end

    it "does not update the news" do
      expect(@news.title.blank?).to be(false)
    end

    it "renders the edit form" do
      expect(response).to render_template(:edit)
    end
  end

  describe "POST :notify" do
    it "sends the notices" do
      allow(@news).to receive(:notify)

      post :notify, id: @news.id, news: { from: "fred.flintstone@harman.com", to: "barney.rubble@harman.com" }

      expect(response).to redirect_to(admin_news_path(@news))
    end
  end

  describe "DELETE :destroy" do
    before do
      @other_news = FactoryGirl.create(:news, brand: @brand)
      delete :destroy, id: @other_news.id
    end

    it "deletes the news" do
      expect(News.exists?(id: @other_news.id)).to be(false)
    end

    it "redirects_to the admin news index" do
      expect(response).to redirect_to(admin_news_index_path)
    end
  end
end
