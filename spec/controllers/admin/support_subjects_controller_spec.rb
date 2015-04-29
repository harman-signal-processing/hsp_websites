require "rails_helper"

RSpec.describe Admin::SupportSubjectsController, type: :controller do

  before :all do
    @website = FactoryGirl.create(:website_with_products)
    @brand = @website.brand
    @support_subjects = FactoryGirl.create_list(:support_subject, 2, brand_id: @brand.id)
    @user = FactoryGirl.create(:user, market_manager: true, confirmed_at: 1.minute.ago)
  end

  before :each do
    @request.host = @website.url
    sign_in(:user, @user)
  end

  describe "GET index" do
    before do
      get :index
    end

    it "should have successful response" do
      expect(response).to be_success
    end

    it "assigns @support_subjects" do
      expect(assigns(:support_subjects)).to eq(@support_subjects)
    end

    it "renders admin/support_subjects/index" do
      expect(response).to render_template("admin/support_subjects/index")
    end
  end

  describe "GET new" do
    before do
      get :new
    end

    it "assigns @support_subject" do
      expect(assigns(:support_subject)).to be_a(SupportSubject)
    end

    it "assigns the current brand as the new subjects brand" do
      expect(assigns(:support_subject).brand).to eq(@brand)
    end

    it "renders the new form" do
      expect(response).to render_template("admin/support_subjects/new")
    end
  end

  describe "POST create" do
    before do
      @valid_params = { name: "Call my mom", recipient: "mom@home.com" }
    end

    it "creates a new support subject" do
      num = SupportSubject.count

      post :create, support_subject: @valid_params

      expect(SupportSubject.count).to eq(num + 1)
    end

    it "assigns the new subject to the site's brand" do
      post :create, support_subject: @valid_params

      expect(SupportSubject.last.brand_id).to eq(@brand.id)
    end
  end

  describe "GET show" do
    before do
      get :show, id: @support_subjects.first.id
    end

    it "renders the show template" do
      expect(response).to render_template("admin/support_subjects/show")
    end
  end

  describe "GET edit" do
    before do
      get :edit, id: @support_subjects.first.id
    end

    it "renders the edit template" do
      expect(response).to render_template("admin/support_subjects/edit")
    end
  end

  describe "POST update" do
    before do
      @support_subject = @support_subjects.first
      post :update, id: @support_subject.id, support_subject: { recipient: "my.mom.rules@theblock.com" }
    end

    it "updates the subject" do
      @support_subject.reload
      expect(@support_subject.recipient).to eq("my.mom.rules@theblock.com")
    end

    it "redirects to the index" do
      expect(response).to redirect_to(admin_support_subject_path(@support_subject))
    end
  end

  describe "DELETE destroy" do
    before do
      @support_subject = @support_subjects.first
      delete :destroy, id: @support_subject.id
    end

    it "removes the subject" do
      subjects = SupportSubject.where(brand_id: @brand.id)
      expect(subjects).not_to include(@support_subject)
    end

    it "redirects to the support subjects index" do
      expect(response).to redirect_to(admin_support_subjects_path)
    end
  end
end
