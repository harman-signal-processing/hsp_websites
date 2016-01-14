require "rails_helper"

RSpec.describe Admin::FaqsController, type: :controller do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
    @faq_category = FactoryGirl.create(:faq_category, brand: @brand)
    @user = FactoryGirl.create(:user, market_manager: true, confirmed_at: 1.minute.ago)
  end

  before :each do
    @request.host = @website.url
    sign_in(:user, @user)
  end

  describe "POST create" do
    before do
      @valid_params = { question: "Should I call my mom?", answer: "Yes.", faq_category_ids: [ @faq_category.id ] }

      post :create, faq: @valid_params
    end

    it "creates a new faq" do
      expect(Faq.count).to eq(1)
    end

    it "assigns the new faq to the category" do
      new_faq = Faq.last
      @faq_category.reload

      expect(@faq_category.faqs).to include(new_faq)
    end

    it "directs to the faq" do
      new_faq = Faq.last

      expect(response).to redirect_to(admin_faq_path(new_faq))
    end
  end
end
