require 'rails_helper'

RSpec.describe SupportController, :type => :controller do

  before :all do
    @website = FactoryGirl.create(:website)
    @brand = @website.brand
  end

  before :each do
    @request.host = @website.url
  end

  describe "GET catalog_request" do
    before do
      get :catalog_request
    end

    it "initializes a contact_message" do
      expect(assigns(:contact_message)).to be_a_new(ContactMessage)
    end

    it "returns http success and renders template" do
      expect(response).to have_http_status(:success)
      expect(response).to render_template("catalog_request")
    end
  end

  describe "POST catalog_request" do

    before do
      post :catalog_request, contact_message: {
        name: "Joe Schmoe",
        email: "joe@schmoe.com",
        shipping_address: "123 Nowhere",
        shipping_city: "Somewhere",
        shipping_state: "IN",
        shipping_zip: "90210",
        shipping_country: "United States"
      }
    end

    it "sends catalog request" do
      expect(assigns(:contact_message).name).to eq("Joe Schmoe")
      expect(assigns(:contact_message).message_type).to eq("catalog_request")
      expect(assigns(:contact_message).valid?).to be(true)
    end

    it "records the brand of the site where the form was submitted" do
      expect(assigns(:contact_message).brand).to eq(@brand)
    end

    it "returns to the support page, i guess" do
      expect(response).to redirect_to(support_path)
    end
  end

  describe "POST contact" do
    before do
      post :contact, contact_message: {
        name: "Joe Schmoe",
        email: "joe@schmoe.com",
        product: "cool-product",
        subject: "Technical Support"
      }
    end

    it "records the brand of the site where the form was submitted" do
      expect(assigns(:contact_message).brand).to eq(@brand)
    end

  end

  describe "GET parts" do

    it "renders the parts form" do
      @brand.update_column(:has_parts_form, true)
      get :parts
      expect(response).to render_template('support/parts')
    end

    describe "brand doesn't offer parts form" do
      before do
        @brand.update_column(:has_parts_form, false)
        get :parts
      end

      # 4/2015 There have been problems with the Crown parts and RMA
      # forms. I'm temporarily removing the filter to redirect non-parts
      # brands so we can see if that is the problem...
      it "redirects to support page" do
        skip "Temporarily allowing parts page even for non-parts brands"
        expect(response).to redirect_to(support_path)
      end

      it "renders the parts form anyway (for now)" do
        expect(response).to render_template('support/parts')
      end

      it "logs the attempt" do
        last_log = AdminLog.last

        expect(last_log.action).to match(/Parts form attempted/)
        expect(last_log.website_id).to eq(@website.id)
      end
    end
  end

  describe "POST parts" do

    before do
      @brand.update_column(:has_parts_form, true)
      post :parts, contact_message: {
        name: "Joe Schmoe",
        email: "joe@schmoe.com",
        product: "cool-product"
      }
    end

    it "flags the message type as part_request" do
      expect(assigns(:contact_message).message_type).to eq("part_request")
    end

    it "records the brand of the site where the form was submitted" do
      expect(assigns(:contact_message).brand).to eq(@brand)
    end
  end

  describe "GET rma" do

    it "renders the rma form" do
      @brand.update_column(:has_rma_form, true)
      get :rma
      expect(response).to render_template('support/rma')
    end

    describe "brand doesn't offer RMA" do
      before do
        @brand.update_column(:has_rma_form, false)
        get :rma
      end

      # 4/2015 There have been problems with the Crown parts and RMA
      # forms. I'm temporarily removing the filter to redirect non-parts
      # brands so we can see if that is the problem...
      it "redirects to support page" do
        skip "Temporarily allowing this to debug RMA problems"
        expect(response).to redirect_to(support_path)
      end

      it "renders the rma form anyway (for now)" do
        expect(response).to render_template('support/rma')
      end

      it "logs the attempt" do
        last_log = AdminLog.last

        expect(last_log.action).to match(/RMA attempted/)
        expect(last_log.website_id).to eq(@website.id)
      end
    end
  end

  describe "POST rma" do
    before do
      @brand.update_column(:has_rma_form, true)
      post :rma, contact_message: {
        name: "Joe Schmoe",
        email: "joe@schmoe.com",
        product: "cool-product"
      }
    end

    it "flags the message type as rma_request" do
      expect(assigns(:contact_message).message_type).to eq("rma_request")
    end

    it "records the brand of the site where the form was submitted" do
      expect(assigns(:contact_message).brand).to eq(@brand)
    end

  end

end
