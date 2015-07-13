require "rails_helper"

feature "Admin epedal Labels", :devise do
  include ActiveJob::TestHelper

  before :all do
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand, istomp_coverflow: 1, url: "digitech.lvh.me")
    @istomp = FactoryGirl.create(:product, name: "iStomp", brand: @brand, layout_class: "istomp")
    @gooberator = FactoryGirl.create(:product, name: "Gooberator", brand: @brand, layout_class: "epedal")
    @fooberator = FactoryGirl.create(:product, name: "Fooberator", brand: @brand, layout_class: "epedal")
    FactoryGirl.create(:parent_product, product: @gooberator, parent_product: @istomp)
    FactoryGirl.create(:parent_product, product: @fooberator, parent_product: @istomp)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @sheet = FactoryGirl.create(:label_sheet, products: [@gooberator.id, @fooberator.id].join(", "))
    @user = FactoryGirl.create(:user, market_manager: true, password: "password", confirmed_at: 1.second.ago)
  end

  before :each do
    allow_any_instance_of(Website).to receive(:epedal_label_order_recipient).and_return("epedal_fulfillment@harman.com")
    admin_login_with(@user.email, "password", @website)
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  describe "managing label sheets" do
    before do
      @zooberator = FactoryGirl.create(:product, name: "Fooberator", brand: @brand, layout_class: "epedal")
      FactoryGirl.create(:parent_product, product: @zooberator, parent_product: @istomp)
      visit admin_label_sheets_path(locale: I18n.default_locale)
    end

    it "should list current sheets" do
      expect(page).to have_link @sheet.name, href: admin_label_sheet_path(@sheet, locale: I18n.default_locale)
    end

    it "should create a new sheet" do
      click_on "New label sheet"
      fill_in 'label_sheet_name', with: "Yo Mama"
      fill_in 'label_sheet_products', with: @zooberator.to_param
      click_on 'Create'

      expect(page).to have_content "Yo Mama"
      expect(LabelSheet.last.decoded_products).to include(@zooberator)
    end
  end

  describe "managing label sheet orders" do
    before do
      @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id], subscribe: true)
      visit admin_label_sheet_orders_path(locale: I18n.default_locale)
    end

    it "should link to existing orders" do
      expect(page).to have_link @order.name
    end

    it "should show the order details" do
      click_on @order.name

      expect(page).to have_content @order.address
      expect(page).to have_content @order.city
      expect(page).to have_content @order.state
      expect(page).to have_content @order.postal_code
      expect(page).to have_content @order.email
      expect(page).to have_content @order.country
      expect(page).to have_content @order.expanded_label_sheets.first.name
      expect(page).to have_content "Subscribe? Yes"
    end

  end

  describe "label order fulfillment" do
    before do
      @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id, @sheet.id])
      visit admin_label_sheet_order_path(@order, locale: I18n.default_locale)
    end

    it "should send an email to the user with the mailing date" do
      perform_enqueued_jobs do
        click_link 'mark shipped'

        @order.reload
        expect(@order.mailed_on.blank?).to be false
        expect(page).to have_content "Success"

        last_email = ActionMailer::Base.deliveries.last
        expect(last_email.to).to include(@order.email)
        expect(last_email.subject).to include("epedal labels")
        expect(last_email.body).to include "today"
      end
    end

  end

  describe "data export" do
    before do
      @order = FactoryGirl.create(:label_sheet_order, label_sheet_ids: [@sheet.id, @sheet.id])
      visit admin_label_sheet_orders_path(locale: I18n.default_locale)
    end

    it "should have a button to export all" do
      expect(page).to have_link "Export All", href: admin_label_sheet_orders_path(format: 'xls', locale: I18n.default_locale)
    end

    # it "should respond with an excel file for all" do
    #   click_on "Export All"
    #   page.wont_have_content "Error"
    # end

    it "should have a button to export subscribers only" do
      expect(page).to have_link "Export Subscribers", href: subscribers_admin_label_sheet_orders_path(format: 'xls', locale: I18n.default_locale)
    end

    # it "should respond with an excel file for subscribers" do
    #   click_on "Export Subscribers"
    #   page.wont_have_content "Error"
    # end
  end

end
