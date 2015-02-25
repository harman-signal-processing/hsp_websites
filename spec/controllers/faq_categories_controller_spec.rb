require 'rails_helper'

RSpec.describe FaqCategoriesController, :type => :controller do

  before do
    @brand = FactoryGirl.create(:crown_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "crown", brand: @brand, url: "crown.lvh.me")
    @faq_category = FactoryGirl.create(:faq_category, brand: @brand)
    @faq_category.faqs << FactoryGirl.create(:faq)
    @request.host = @website.url
  end

  describe "GET index" do
    it "returns http success" do
      get :index

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it "loads the brand's categories" do
      some_other_category = FactoryGirl.create(:faq_category)

      get :index

      expect(assigns(:faq_categories)).to include(@faq_category)
      expect(assigns(:faq_categories)).not_to include(some_other_category)
    end
  end

  describe "GET show" do
    before do
      get :show, id: @faq_category.id
    end

    it "assigns the faq category" do
      expect(assigns(:faq_category)).to eq(@faq_category)
    end

    it "returns http success" do
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:success)
    end
  end

end
